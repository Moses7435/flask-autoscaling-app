from flask import Flask, jsonify
import socket

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify(
        message="Flask App Running Successfully!",
        hostname=socket.gethostname()
    )

@app.route("/health")
def health():
    return "OK", 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
