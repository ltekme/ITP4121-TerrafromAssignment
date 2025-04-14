import os

import sqlalchemy as sa
import sqlalchemy.orm as so

from http import HTTPMethod, HTTPStatus
from flask import Flask, render_template, request, Response, redirect

from .model import TableBase, Item
from .bgBurner import materialsInBurner, addMaterialsToBurner, removeMaterialsFromBurner

app = Flask(__name__)

dbUri = os.environ.get("APP_DB_URL") or "sqlite:///./app.db"
dbEngine = sa.create_engine(
    url=dbUri,
    connect_args={
        'check_same_thread': False
    })
dbSession = so.Session(dbEngine)

try:
    dbSession.query(Item).first()
except:
    TableBase.metadata.create_all(dbEngine)


@app.before_request
def checkBurner():
    burnerMaterialCount = len(materialsInBurner)
    if burnerMaterialCount >= int(os.environ.get("APP_MAX_BURN_MATERIAL", 10)):
        return
    itemsCount = dbSession.query(Item).where(
        Item.status == "In-Inventory"
    ).filter(
        Item.name.startswith("BurnerMaterial")
    ).count()
    requiredBurningMaterial = itemsCount - burnerMaterialCount
    print(
        f"Items in inventory: {itemsCount}, item in burner: {burnerMaterialCount}")

    if requiredBurningMaterial > 0:
        addMaterialsToBurner(requiredBurningMaterial)
    if requiredBurningMaterial < 0:
        removeMaterialsFromBurner(-requiredBurningMaterial)

    return


@app.route("/", methods=[HTTPMethod.POST, HTTPMethod.GET])
def item_CR():
    if request.method == HTTPMethod.GET:
        items = dbSession.query(Item).all()
        return render_template("index.html.j2", items=items)

    requestData = request.get_json() or {}
    item = Item()
    item.name = requestData.get("name")
    item.description = requestData.get("description")
    item.status = requestData.get("status")
    dbSession.add(item)
    dbSession.commit()
    return Response(status=HTTPStatus.OK, response="ok")


@app.route("/<id>", methods=[HTTPMethod.PUT, HTTPMethod.GET, HTTPMethod.DELETE])
def item_RUD(id: int):
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
    dbSession.commit()
    return Response(status=HTTPStatus.OK, response="ok")
