import os

import sqlalchemy as sa
import sqlalchemy.orm as so

from http import HTTPMethod, HTTPStatus
from flask import Flask, render_template, request, Response, redirect

from .model import TableBase, Item
from .bgBurner import materialsInBurner, addMaterialsToBurner, removeMaterialsFromBurner

app = Flask(__name__)

dbUri = os.environ.get("APP_DB_URL") or "sqlite:///./app.db"
dbArgs = {}
if dbUri.startswith("sqlite:///"):
    dbArgs['check_same_thread'] = False
dbEngine = sa.create_engine(url=dbUri, connect_args=dbArgs)
dbSession = so.Session(dbEngine)

# create the database table if it doesn't exists
try:
    dbSession.query(Item).first()
except:
    dbSession.rollback()
    TableBase.metadata.create_all(dbEngine)


def isValidItem(item: Item) -> bool:
    if item.name is None or item.description is None or item.status is None:
        return False
    return True


def checkBurner():
    burnerMaterialCount = len(materialsInBurner)
    if burnerMaterialCount >= int(os.environ.get("APP_MAX_BURN_MATERIAL", 10)):
        return

    try:
        itemsCount = dbSession.query(Item).where(
            Item.status == "In-Inventory"
        ).filter(
            Item.name.startswith("BurnerMaterial")
        ).count()
    except:
        dbSession.rollback()
        return

    requiredBurningMaterial = itemsCount - burnerMaterialCount
    app.logger.debug(
        f"Items in inventory: {itemsCount}, item in burner: {burnerMaterialCount}")

    if requiredBurningMaterial > 0:
        addMaterialsToBurner(requiredBurningMaterial)
    if requiredBurningMaterial < 0:
        removeMaterialsFromBurner(-requiredBurningMaterial)

    return


@app.route("/", methods=[HTTPMethod.POST, HTTPMethod.GET])
def item_CR():
    try:
        if request.method == HTTPMethod.GET:
            items = dbSession.query(Item).all()
            return render_template("index.html.j2", items=items)
        requestData = request.get_json() or {}
        item = Item()
        item.name = requestData.get("name")
        item.description = requestData.get("description")
        item.status = requestData.get("status")
        if not isValidItem(item):
            return Response(status=HTTPStatus.BAD_REQUEST)
        dbSession.add(item)
        dbSession.commit()
        return Response(status=HTTPStatus.OK, response="ok")
    except:
        dbSession.rollback()
        return Response(status=HTTPStatus.INTERNAL_SERVER_ERROR)


@app.route("/item/<id>", methods=[HTTPMethod.PUT, HTTPMethod.GET, HTTPMethod.DELETE])
def item_RUD(id: int):
    try:

        item: Item = dbSession.query(Item).get(id)
        if item is None and request.method == HTTPMethod.GET:
            return redirect("/")

        if request.method == HTTPMethod.GET:
            return render_template("edit.html.j2", item=item)

        if request.method == HTTPMethod.DELETE:
            dbSession.delete(item)
            dbSession.commit()
            return Response(status=HTTPStatus.OK, response="ok")

        requestData = request.get_json() or {}
        item.name = requestData.get("name")
        item.description = requestData.get("description")
        item.status = requestData.get("status")
        if not isValidItem(item):
            return Response(status=HTTPStatus.BAD_REQUEST)
        dbSession.commit()
        return Response(status=HTTPStatus.OK, response="ok")
    except:
        dbSession.rollback()
        return Response(status=HTTPStatus.INTERNAL_SERVER_ERROR)
