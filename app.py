from flask import Flask, jsonify
import socket
import os

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify(
        message="🚀 Flask App Running Successfully!",
        service="Auto Scaling + ALB + Docker + Terraform",
        hostname=socket.gethostname()
    )

@app.route("/health")
def health():
    return "OK", 200

@app.route("/info")
def info():
    return jsonify(
        app="Flask DevOps Demo",
        version="1.0",
        environment=os.environ.get("ENV", "production")
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
