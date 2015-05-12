import sys
import json
import requests
from bs4 import BeautifulSoup

def getambience(ambience):
	casual = ["casual", "trendy", "hipster", 'touristy']
	upscale = ["upscale", "classy", "touristy"]
	romantic = ["romantic", "intimate"]
	ans = [];
	for a in ambience.split(","):
		a = a.strip()
		if a in casual:
			ans.append("casual")
		elif a in upscale:
			ans.append("upscale")
		elif a in romantic:
			ans.append("romantic")
	print(ans)
	return ans;

with open('final2.json') as data_file: 
	data = json.load(data_file)
yelp = list(data)
count = 0;
new = []

for b in yelp:
	url = b["url"]	
	print(url)
	html_doc = requests.get(url)
	soup = BeautifulSoup(html_doc.text)
	title = soup.find('title').get_text()
	if (title.lower().find("closed") == -1):
		times = []
		for day in soup.find_all('tr'):
			time = ""
			filler = ""
			tdtext = day.find('td').get_text().strip()
			if (tdtext == "Closed"):
				time = "0"
			elif (tdtext == "Open 24 hours"):
				time = "24"
			for hour in day.find_all('span'):
				if (hour.get_text()[0].isdigit()):
					time = time + filler + hour.get_text()
					if (filler == "-"):
						filler = ", "
					else:
						filler = "-"
			times.append(time)
		ambience = ""
		parking = ""
		meal = ""
		options = "000000"
		options = list(options)
		for attr in soup.find_all('dl'):
			num = -1
			name = attr.dt.get_text().strip()
			if(name == "Takes Reservations"):
				ans = attr.dd.get_text()
				num = 0
			#elif(name == "Delivery"):
			#	ans = attr.dd.get_text()
			#	num = 1
			elif(name == "Take-out"):
				ans = attr.dd.get_text()
				num = 1
			elif(name == "Accepts Credit Cards"):
				ans = attr.dd.get_text()
				num = 2
			#elif(name == "Wheelchair Accessible"):
			#	ans = attr.dd.get_text()
			#	num = 4
			#elif(name == "Good for Kids"):
			#	ans = attr.dd.get_text()
			#	num = 5
			#elif(name == "Good for Groups"):
			#	ans = attr.dd.get_text()
			#	num = 6
			elif(name == "Alcohol"):
				ans = attr.dd.get_text()
				num = 3
			elif(name == "Outdoor Seating"):
				ans = attr.dd.get_text()
				num = 4
			#elif(name == "Waiter Service"):
			#	ans = attr.dd.get_text()
			#	num = 9
			elif(name == "Wi-Fi"):
				ans = attr.dd.get_text()
				num = 5
			#elif(name == "Caters"):
			#	ans = attr.dd.get_text()
			#	num = 11
			elif(name == "Ambience"):
				ambience = attr.dd.get_text().strip()
			elif(name == "Good For"):
				meal = attr.dd.get_text().strip()
			elif(name == "Parking"):
				parking = attr.dd.get_text().strip()
			if (num != -1):
				if (ans.strip() == "No"):
					options[num] = 1
				else:
					options[num] = 2
		options = "".join(str(x) for x in options)
		b["options"] = options
		b["hours"] = times
		b["parking"] = parking
		ambience = ambience.lower()
		b["ambience"] = getambience(ambience)
		b["meal"] = meal
		if (soup.find(itemprop="telephone") == None):
			b["phone_number"] = ""
		else:
			b["phone_number"] = soup.find(itemprop="telephone").get_text().strip()
		if (soup.find(height="250") == None):
			b["big_img_url"] = ""
		else:
			b["big_img_url"] = soup.find(height="250")['src']
		if (soup.find(itemprop="priceRange") == None):
			b["cost"] = ""
		else:
			b["cost"] = soup.find(itemprop="priceRange").get_text()
		new.append(b)
with open('final3.json', 'w') as outfile:
    json.dump(new, outfile)
