from flask import Flask, render_template, request
from flask_pymongo import PyMongo 
import datetime

app = Flask(__name__)

#setup mongo connection
app.config["MONGO_URI"] = "mongodb://localhost:27017/shows_db"
mongo = PyMongo(app)

#connect to collection
tv_shows = mongo.db.tv_shows


#READ
@app.route("/")
def index():
    #Find all the items in the db and save to a variable
    all_shows = list(tv_shows.find())
    print(all_shows)

    return render_template("index.html", data=all_shows)

#CREATE
@app.route("/add_create", methods=['POST', 'GET'])
def add_create():
    if request.method == "POST":
        data = request.form 
        post_data = {'name': data['name'],
        'seasons': data['seasons'],
        'duration': data['duration'],
        'date_added': datetime.datetime.utcnow()
        }

        tv_shows.insert_one(post_data)

    else:
        return render_template("add_create.html")


#UPDATE
@app.route("/add_update")
def add_update():
    
    update_data = {"name": input('name')}
    post_data = {"$set": {'name' : input('name'),
    'seasons' : input('seasons'),
    'duration': input('duration'),
    'year': input('year'),
    'date_added':datetime.datetime.utcnow()
    }}
    tv_shows.update_one(update_data, post_data)

    return render_template("index.html", data=post_data)

"""PUT method is showing error, so gave inputs here in the code"""

#DELETE
@app.route("/delete", methods=["DELETE"])
def delete():
    if request.method == "DELETE":
        data = request.form
        tv_shows.delete_one = ({"year":data['year']})
        print("delete")
    else:
        return render_template("delete.html")



if __name__ =="__main__":
    app.run(debug=True)
    