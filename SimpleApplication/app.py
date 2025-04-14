import os
from src import app

if __name__ == "__main__":
    app.run(
        debug=os.environ.get("APP_DEBUG", False) == "true",
        port=int(os.environ.get("APP_PORT", 3000))
    )
