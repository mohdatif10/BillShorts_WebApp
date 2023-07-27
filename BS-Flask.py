from requests_html import HTMLSession
import time
from googlesearch import search
import nest_asyncio
from apscheduler.schedulers.background import BackgroundScheduler
import requests
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import openai
from bs4 import BeautifulSoup
import random
import re
import copy
from urllib.parse import quote
import nltk
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import random
from urllib.parse import urljoin
import sys
sys.path.append(r"c:\users\mohda\anaconda3\lib\site-packages")
import schedule
import time

#https://news.google.com/topics/CAAqKggKIiRDQkFTRlFvSUwyMHZNRGx6TVdZU0JXVnVMVWRDR2dKSlRpZ0FQAQ?hl=en-IN&gl=IN&ceid=IN%3Aen

class BillShorts:
    url = "https://news.google.com/home?hl=en-IN&gl=IN&ceid=IN:en"
    base_url = "https://news.google.com/"
    source_link_list = []
    actual_link_list = []
    message_history = []
    duplicate_message_history= []
    archive_dict = {}
    unique_articles_dict = {}
    temp_dict = {}
    cpl = 8 # computer prowess limitation

    def __init__(self):
        self.message_history = []
        self.archive_dict = {}
        self.source_link_list = []
        self.actual_link_list = []

    # def news(self):
    #     session = HTMLSession()
    #     r = session.get(BillShorts.url)
    #     assert r.status_code == 200

    def get_page(self):
        session = HTMLSession()
        r = session.get(BillShorts.url)
        r.html.render(sleep=1, scrolldown=0, timeout=20)
        return r.html.find("a")

    def main(self):
        # articles = self.get_page()
        # business_links = [a for a in articles if 'aria-label' in a.attrs and a.attrs['aria-label'] == 'Business'][0]
        # BillShorts.url = urljoin(BillShorts.base_url, business_links.attrs['href'])
        # print(BillShorts.url)
        BillShorts.url="https://news.google.com/topics/CAAqKggKIiRDQkFTRlFvSUwyMHZNRGx6TVdZU0JXVnVMVWRDR2dKSlRpZ0FQAQ?hl=en-IN&gl=IN&ceid=IN%3Aen"
        print(BillShorts.url)
        articles = self.get_page()  # redoing as we got a new URL above

        for article in articles:
            a_tag = article.find("a", first=True)  # Find the first <a> tag within the article
            if a_tag:
                href = a_tag.attrs.get("href")
                if href is not None and href.startswith("./articles"):
                    self.source_link_list.append(urljoin(self.base_url, href))

        print("len-source_link_list", len(self.source_link_list))  
        self.source_link_list=self.source_link_list[:70]
        random.shuffle(self.source_link_list)
              

    def getting_actual_url(self, gad_url):
        response = requests.get(gad_url, allow_redirects=True)
        actual_url = response.url
        return actual_url

    def get_actual_destination_url_main(self, url_list):
        for source_url in url_list[:self.cpl]: 
            actual_destination = self.getting_actual_url(source_url)
            self.actual_link_list.append(actual_destination)

    def run1(self):
        self.get_actual_destination_url_main(self.source_link_list)

    # https://www.youtube.com/watch?v=c-g6epk3fFE
    def chat(self, inp, role="user"):
        openai.api_key = open("key.txt", "r").read().strip('\n')

        # Add the current input to the message_history
        self.message_history.append({"role": role, "content": inp})

        # Make a deep copy of the current message_history to store the complete conversation
        self.duplicate_message_history = self.message_history

        completion = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[{"role": message["role"], "content": message["content"]} for message in self.duplicate_message_history]
        )

        reply_content = completion.choices[0].message.content
        print(reply_content)
        self.duplicate_message_history.append({"role": "assistant", "content": reply_content})

        return reply_content

    def run2(self):
        self.duplicate_message_history = [] 

        for article_link in self.actual_link_list[:self.cpl]:
            prompt = f"Give me a DETAILED 60-word financial summary with a short title for - {article_link}. Mention the title as Title:..."
            print("prompt ", prompt)
            self.chat(prompt)
            print()
        self.message_history=self.duplicate_message_history

    def import_from_firestore(self):
        try:
            # Initialize Firebase Admin SDK
            cred = credentials.Certificate('bill-shorts-firebase-adminsdk-5prnm-a1715a609c.json')
            firebase_admin.initialize_app(cred)
        except ValueError:
            pass

        # Get a reference to the Firestore database
        db = firestore.client()
        # Export from Firestore data
        docs = db.collection('archive').get()

        for doc in docs:
            doc_data = doc.to_dict()
            BillShorts.temp_dict[doc.id] = doc_data


        print("Length of Firestore data", len(self.temp_dict))

    def web_scrape_article_image(self, article_url, article_title):
        try:
            # Send a request to the article URL
            response = requests.get(article_url)
            soup = BeautifulSoup(response.content, 'html.parser')

            # Check for Open Graph tags
            og_image = soup.find('meta', property='og:image')
            if og_image and 'content' in og_image.attrs:
                return og_image['content']

            # If Open Graph tags are not found, search for other image tags
            image_element = soup.find('img')
            if image_element and 'src' in image_element.attrs:
                return image_element['src']
            
            # If Open Graph tags are not found, search for the article title in Google Images
            else:
                url = 'https://www.google.com/search?q={0}&tbm=isch'.format(article_title)
                content = requests.get(url).content
                soup = BeautifulSoup(content, 'html.parser')
                images = soup.findAll('img')

                # Extract the URL of the first image from the search results
                first_image_url = None
                for img in images:
                    src = img.get('src')
                    if src and src.startswith('https'):
                        first_image_url = src
                        break

                return first_image_url
        
        except:
            return "No image found"

    def run3(self):
        num_articles_in_message_history = 0
        articles = []

        for data in self.message_history:
            if data["role"] == "assistant":
                num_articles_in_message_history += 1

        print("num_articles_in_message_history:", num_articles_in_message_history)

        i = len(self.temp_dict)
        article_titles_list=[]

        for i in range(i, i + num_articles_in_message_history):
            self.archive_dict[i] = {}
            i += 1

        i = len(self.temp_dict)

        for data in self.message_history:
            content_parts = []
            title = "" 
            article = ""

            if data["role"] == "assistant":
                content_parts = data["content"].split('\n', 1)

            if len(content_parts) >= 2:
                title, article = content_parts
                title = title.replace("Title:", "").strip()
                article = article.strip()

                self.archive_dict[i]["title"] = title
                self.archive_dict[i]["content"] = article
                self.archive_dict[i]["date_time"] = time.strftime("%Y-%m-%d %H:%M", time.localtime())
                i += 1

                article_titles_list.append(title)

        i = len(self.temp_dict)
        
        for link, title in zip(self.actual_link_list[:self.cpl], article_titles_list):
            # Call web_scrape_article_image with the article title as an argument
            x = self.web_scrape_article_image(link, title)

            self.archive_dict[i]["title"] = title
            self.archive_dict[i]["image_url"] = x
            self.archive_dict[i]["dest_link"] = link
            i += 1

            
    def similarity_score(self):
        articles = []

        for data_point in self.archive_dict.values():
            if "content" in data_point:
                articles.append(data_point["content"])

        # Preprocess the text and create BoW representation
        preprocessed_articles = []
        for article in articles:
            tokenizer = nltk.RegexpTokenizer(r"\w+")
            preprocessed_article = " ".join(tokenizer.tokenize(article.lower()))
            preprocessed_articles.append(preprocessed_article)

        vectorizer = CountVectorizer()
        bow_matrix = vectorizer.fit_transform(preprocessed_articles)
        bow_array = bow_matrix.toarray()

        # Calculate similarity scores
        num_articles = len(articles)
        similarity_scores = [[0] * num_articles for _ in range(num_articles)]

        for i in range(num_articles):
            for j in range(i + 1, num_articles):
                similarity_scores[i][j] = cosine_similarity([bow_array[i]], [bow_array[j]])[0][0]
                similarity_scores[j][i] = similarity_scores[i][j]

        # for i, article in enumerate(articles):
        #     print(f"Similarity scores for '{article}':")
        #     for j, other_article in enumerate(articles):
        #         if i != j:
        #             print(f"  with '{other_article}': {similarity_scores[i][j]}")

        unique_articles = []
        visited = set()

        for i in range(num_articles):
            if i not in visited:
                similar_articles = [j for j, score in enumerate(similarity_scores[i]) if score >= 0.55]
                if len(similar_articles) > 0:
                    random_article = random.choice(similar_articles)
                    visited.update(similar_articles)
                    unique_articles.append(articles[random_article])
                else:
                    unique_articles.append(articles[i])

        for i, article in enumerate(unique_articles):
            for key, data_point in self.archive_dict.items():
                if data_point.get("content") == article:
                    self.unique_articles_dict[key] = data_point
                    break

        print("Length of unique_articles ", len(unique_articles))

    def export_to_firestore(self):
        try:
            # Initialize Firebase Admin SDK
            cred = credentials.Certificate('bill-shorts-firebase-adminsdk-5prnm-a1715a609c.json')
            firebase_admin.initialize_app(cred)
        except ValueError:
            pass

        # Connect to the Firebase database
        db = firestore.client()

        # Export data to the database
        
        i=len(self.temp_dict)+1

        for key, value in self.unique_articles_dict.items():
            article_number = int(i)
            value["article_number"] = article_number

            doc_ref = db.collection('archive').document(str(i))
            doc_ref.set(value)
            i+=1
        
        print("Data exported to Firebase successfully!")

def run_sync():
    obj = BillShorts()

    # obj.news()
    obj.main()
    obj.run1()

    obj.run2()

    obj.import_from_firestore()

    try:
        # Initialize OpenAI API key inside the function
        openai.api_key = open("key.txt", "r").read().strip('\n')
    except Exception as e:
        print("Error initializing OpenAI API key:", e)
        return

    max_retries = 5  # Maximum number of retries
    retries = 0
    backoff_time = 2  # Initial backoff time in seconds

    while retries < max_retries:
        try:
            obj.run2()
            break  # If successful, break out of the retry loop
        except openai.error.ServiceUnavailableError:
            print("ServiceUnavailableError. Retrying...")
            time.sleep(backoff_time)
            backoff_time *= 2  # Increase the backoff time exponentially
            retries += 1
    else:
        print("Max retries reached. Unable to complete the task.")

    obj.run3()
    obj.similarity_score()
    obj.export_to_firestore()


def run_sync_scheduler():
    # Run the function immediately for the first time
    run_sync()

    # Schedule the function to run every 2 minutes
    schedule.every(1).hour.do(run_sync)

    # Keep the script running to continue scheduling the task
    while True:
        schedule.run_pending()
        time.sleep(1)

if __name__ == "__main__":
    run_sync_scheduler()

