from logging import exception

from flask import Flask, jsonify, request
import logging
import urllib.request
import re

# init flask app , logging and response data.
app = Flask(__name__)
logging.basicConfig(level=logging.INFO, filename='myapp.log', format='%(asctime)s %(levelname)s:%(message)s')
response_data = {}

#Get jokes from bash.org.pl/text and return them in dictionary.
def get_jokes():
    global response_data
    jokes_dict_arr = []
    try:
        # Send Get request to bash.org.pl.
        url = "https://web.archive.org/web/20200805170615if_/http://bash.org.pl:80/text"
        bash_org_bl_response = urllib.request.urlopen(url)
        # Read the data (text format) from response.
        data = bash_org_bl_response.read().decode()
        # Regular expression tp parse joke_id , joke_url and joke_text.
        query = re.compile("(?<=\#)([0-9]+) \((.+)\)\n([^%]*\n*)(?=%)", re.MULTILINE)
        # Store the parsing result in array of tuple.
        jokes_tuple_arr = query.findall(data)
        # Select first 100 jokes and store int in array of dictionary.
        for i in range(100):
            joke_dict = {}
            joke_dict["id"] = jokes_tuple_arr[i][0]
            joke_dict["url"] = jokes_tuple_arr[i][1]
            joke_dict["joke"] = jokes_tuple_arr[i][2]
            jokes_dict_arr.append(joke_dict)
        # if the bash.org.pl request success, build response data as dictionary which contain 100 jokes in data key.
        response_data["status"] = "Success"
        response_data["message"] = "bash.org.pl is UP and return data"
        response_data["data"] = jokes_dict_arr
        app.logger.info("Get jokes from bash.org.pl - Success")
    except Exception as e:
        # if the bash.org.pl request fail, build response data as dictionary which contains message error and empty data.
        response_data["status"] = "Fail"
        response_data["message"] = "bash.org.pl is DOWN with this error message : "+str(e)
        response_data["data"] = jokes_dict_arr
        app.logger.error("Get jokes from bash.org.pl - Fail")

    return response_data


#Customized page for 404 Error
@app.errorhandler(404)
def page_not_found(e):
    app.logger.error("404 From: " + str(request.remote_addr))
    return "<h1>404</h1><p>The resource could not be found.</p>",404


#Home page handeler
@app.route("/")
def handle_root():
    try:
        app.logger.info("Get / From: "+str(request.remote_addr))
        global response_data
        # if response data is empty run get_jokes function
        if response_data == {}:
            response_data = get_jokes()
        # Return jokes in json format
        return jsonify(response_data)
    except Exception as e:
        app.logger.error(e)

if __name__ == "__main__":
    try:
        # Run app and listen on all interface and port 5000
        app.run(host="0.0.0.0", port=int("5000"), debug=True)
    except Exception as e:
        app.logger.error(e)
