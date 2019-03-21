from flask import Flask
import requests
app = Flask(__name__)


def get_city(city):
    result = requests.get("https://www.metaweather.com/api/location/search/?query={}".format(city)).json()
    return result[0]["woeid"]


def get_weather(city_id):
    result = requests \
        .get('https://www.metaweather.com/api/location/{}/'.format(city_id)).json()

    return result["consolidated_weather"][0]["the_temp"]

def get_temperature(city):
    city_id = get_city(city)
    temperature = get_weather(city_id)

    return temperature


print(get_temperature("boston"))
