from flask import Flask, render_template, request
from googleapiclient.discovery import build
from config import API_KEY
from dotenv import load_dotenv
import os

app = Flask(__name__)

load_dotenv()  # Loads .env file

API_KEY = os.getenv("YOUTUBE_API_KEY")
print("API KEY =", API_KEY) 

if not API_KEY:
    raise ValueError("API Key not found. Set YOUTUBE_API_KEY in environment or .env file")

# YouTube API client
youtube = build("youtube", "v3", developerKey=API_KEY)

@app.route("/health")
def health():
    return "OK", 200

@app.route("/", methods=["GET", "POST"])
def home():
    videos = []
    selected_video = None

    if request.method == "POST":
        search_query = request.form.get("query")

        # Search request
        search_response = youtube.search().list(
            q=search_query,
            part="snippet",
            type="video",
            maxResults=6
        ).execute()

        # Extract video info
        for item in search_response["items"]:
            video_id = item["id"]["videoId"]
            title = item["snippet"]["title"]
            thumbnail = item["snippet"]["thumbnails"]["medium"]["url"]

            videos.append({
                "id": video_id,
                "title": title,
                "thumbnail": thumbnail
            })

        # Default: play first video
        if videos:
            selected_video = videos[0]["id"]

    return render_template("index.html", videos=videos, selected_video=selected_video)

if __name__ == "__main__":
    app.run(debug=True)

