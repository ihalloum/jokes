import json

# Test That the response data consist of three items
def test_len(app, client):
    res = client.get('/')
    assert res.status_code == 200
    expected = 3
    data=json.loads(res.get_data(as_text=True))
    assert expected == len(data)

# Test That the response data status item include Success or Fail
def test_status(app, client):
    res = client.get('/')
    data = json.loads(res.get_data(as_text=True))
    assert (data["status"] == "Success" or data["status"] =="Fail")

# Test That the response data data item empty if status is fail and include 100 item if status is success.
def test_data(app, client):
    res = client.get('/')
    data = json.loads(res.get_data(as_text=True))
    if data["status"] == "Success":
        expected = 100
        assert expected == len(data["data"])
    else:
        assert data["data"]==[]

