if __name__ == "__main__":
    from src import app
    from waitress import serve
    serve(app, port=3000, host="0.0.0.0")
