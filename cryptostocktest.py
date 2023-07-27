import requests
from alpha_vantage.timeseries import TimeSeries
from datetime import datetime, timedelta
import pytz
import time
import firebase_admin
from firebase_admin import credentials, firestore
import json

def initialize_firebase():
    try:
        # Initialize Firebase Admin SDK
        cred = credentials.Certificate('bill-shorts-firebase-adminsdk-5prnm-a1715a609c.json')
        firebase_admin.initialize_app(cred)
    except ValueError:
        pass

def fetch_stock_data(api_key, symbol):
    ts = TimeSeries(api_key, output_format='pandas')
    # Get yesterday's date
    yesterday = datetime.now(pytz.timezone('America/New_York')) - timedelta(days=1)
    data, meta = ts.get_daily(symbol, outputsize='full')

    # Filter data for yesterday's date
    data = data.loc[data.index.date == yesterday.date()]

    return data, yesterday


def store_stock_info(api_key, stock_name):
    stock_data,yesterday  = fetch_stock_data(api_key, stock_name)
    stock_dict = {}

    if not stock_data.empty:
        latest_info = stock_data.iloc[0]
        stock_dict[stock_name] = {
            'symbol': stock_name,
            'open': latest_info['1. open'],
            'high': latest_info['2. high'],
            'low': latest_info['3. low'],
            'close': latest_info['4. close'],
            'volume': latest_info['5. volume'],
            'latest_available_date': latest_info.name.date().isoformat(),  # Convert date to ISO format string
        }
    else:
        print(f"No data available for {stock_name} on {yesterday.date()}")

    return stock_dict

def fetch_and_store_stock_info():
    # Replace 'YOUR_API_KEY' with the provided Alpha Vantage API keys
    api_key_1 = 'Use your own key'
    api_key_2 = 'Use your own key'
    api_key_3 = 'Use your own key'
    api_key_4 = 'Use your own key'
    api_key_5 = 'Use your own key'

    # Group the stocks and their respective API keys
    stocks_api_group1 = {'TSLA': api_key_1, 'MSFT': api_key_1}
    stocks_api_group2 = {'NVDA': api_key_2, 'GOOGL': api_key_2}
    stocks_api_group3 = {'WMT': api_key_3, 'AMZN': api_key_3}
    stocks_api_group4 = {'PYPL': api_key_4, 'NFLX': api_key_4}
    stocks_api_group5 = {'DIS': api_key_5, 'XOM': api_key_5}

    all_stock_dict = {}
    all_stock_dict.update(store_stock_info_group(stocks_api_group1))
    time.sleep(60)
    all_stock_dict.update(store_stock_info_group(stocks_api_group2))
    all_stock_dict.update(store_stock_info_group(stocks_api_group3))
    time.sleep(60)
    all_stock_dict.update(store_stock_info_group(stocks_api_group4))
    all_stock_dict.update(store_stock_info_group(stocks_api_group5))

    return all_stock_dict

def store_stock_info_group(stocks_api_group):
    stock_dict_group = {}
    for stock_name, api_key in stocks_api_group.items():
        stock_dict = store_stock_info(api_key, stock_name)
        stock_dict_group.update(stock_dict)
    return stock_dict_group

def serialize_date(date_obj):
    return date_obj.isoformat() if hasattr(date_obj, 'isoformat') else date_obj

def get_documents_from_firestore(collection_name):
    # Initialize Firebase Admin SDK
    initialize_firebase()

    db = firestore.client()
    collection_ref = db.collection(collection_name)

    # Create an empty dictionary to store the retrieved data
    temp_stock_dict = {}

    # Retrieve all documents in the collection
    docs = collection_ref.get()

    # Loop through the documents and add them to temp_stock_dict
    for doc in docs:
        stock_symbol = doc.id
        stock_data = doc.to_dict()
        temp_stock_dict[stock_symbol] = stock_data

    return temp_stock_dict

def push_stock_data_to_firestore(stock_dict):
    # Initialize Firebase Admin SDK
    initialize_firebase()
    
    db = firestore.client()

    x=get_documents_from_firestore('stockData')
    i=len(x)

    print("x ", x)
    print("i ", i)
    
    
    for stock_symbol, stock_data in stock_dict.items():
        # Assuming you want to store each stock under a collection called 'stockData'
        doc_ref = db.collection('stockData').document(str(i))
        doc_ref.set(stock_data)
        i+=1

    print("Stock data exported successfully")

# Fetch and store stock information
all_stock_dict = fetch_and_store_stock_info()

# Print the stock information dictionary
print(all_stock_dict)

push_stock_data_to_firestore(all_stock_dict)


def get_currency_exchange_rate(api_key, from_currency, to_currency):
    base_url = "https://rest.coinapi.io/v1/exchangerate"
    endpoint = f"{from_currency}/{to_currency}"
    
    # Parameters for the API request
    params = {
        "apikey": api_key,
    }
    
    # Send the API request
    response = requests.get(f"{base_url}/{endpoint}", params=params)
    
    # Check if the request was successful
    if response.status_code != 200:
        print(f"Error: API request failed with status code {response.status_code}")
        return None

    try:
        data = response.json()
        # Extract the exchange rate from the response
        exchange_rate = data["rate"]
        return exchange_rate
    except requests.exceptions.JSONDecodeError as e:
        print(f"Error: Failed to parse JSON response - {e}")
        print(f"Raw response content:\n{response.text}")
        return None

def fetch_and_store_crypto_exchange_rates(api_key, to_currency, cryptocurrencies):
    exchange_rates = []

    for from_currency in cryptocurrencies:
        exchange_rate = get_currency_exchange_rate(api_key, from_currency, to_currency)

        if exchange_rate is not None:
            print(f"1 {from_currency} equals {exchange_rate} {to_currency}")
            exchange_rates.append({
                'from_currency': from_currency,
                'to_currency': to_currency,
                'exchange_rate': exchange_rate,
                'date': datetime.now().isoformat()
            })

    return exchange_rates

def get_documents_from_firestore(collection_name):
    # Initialize Firebase Admin SDK
    initialize_firebase()

    db = firestore.client()
    collection_ref = db.collection(collection_name)

    # Create an empty dictionary to store the retrieved data
    temp_crypto_dict = {}

    # Retrieve all documents in the collection
    docs = collection_ref.get()

    # Loop through the documents and add them to temp_stock_dict
    for doc in docs:
        crypto_symbol = doc.id
        crypto_data = doc.to_dict()
        temp_crypto_dict[crypto_symbol] = crypto_data

    return temp_crypto_dict


def push_crypto_exchange_rates_to_firestore(exchange_rates):
    # Initialize Firebase Admin SDK
    initialize_firebase()

    db = firestore.client()

    # Assuming you want to store each exchange rate under a collection called 'cryptoExchangeRates'
    collection_ref = db.collection('cryptoData')

    x = get_documents_from_firestore('cryptoData')
    i = len(x)

    for exchange_rate_data in exchange_rates:
        doc_ref = collection_ref.document(str(i))
        doc_ref.set(exchange_rate_data)
        i += 1

    print("Crypto data exported successfully")

# Replace 'YOUR_API_KEY' with your actual API key from CoinAPI
api_key = "Use your own key"
to_currency = "USD"

cryptocurrencies = ["BTC", "ETH", "BNB", "DOGE", "LTC", "XRP"]

# Fetch and store cryptocurrency exchange rates
exchange_rates = fetch_and_store_crypto_exchange_rates(api_key, to_currency, cryptocurrencies)

# Push exchange rates data to Firestore
push_crypto_exchange_rates_to_firestore(exchange_rates)


