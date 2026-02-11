from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "🚀 Flask App Running Successfully with Docker + Auto Scaling!"

@app.route("/health")
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
