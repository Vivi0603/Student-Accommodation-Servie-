import requests

import random as rd
name = [	
"Noah",
"Amelia",
"Oliver",
"Olivia",
"George",
"Isla",
"Leo",
"Ava",
"Theo",
"Freya",
"Arthur",
"Mia",
"Freddie",
"Willow",
"Harry",
"Evie",
"Charlie",
"Lilly",
"Jack", 
"Grace"]

surnames = [
"Smith",
"Johnson",
"Williams",
"Brown",
"Jones",
"Garcia",
"Miller",
"Davis",
"Rodriguez",
"Martinez"]

type = ['Tenant','Homeowner']
location = ['Mumbai',
      'Pune',
      'Bangalore',
      'Delhi']
likes = ["pizza", "icecream", "music", "movies", "travel", "chocolate", "sports", "books", "coffee", "outdoor"]
dislikes = ["cold-calling", "commuting", "presenting", "assignments", "waiting", "cleaning", "enduring", "bills", "crowds", "lines"]
bio = [
    "Software developer with a passion for writing clean, efficient code.",
    "Marketing specialist with experience in branding and social media strategy.",
    "Teacher with a love for inspiring young minds to learn and grow.",
    "Entrepreneur with a drive to innovate and disrupt established industries.",
    "Graphic designer with a keen eye for detail and a strong sense of aesthetics.",
    "Fitness trainer with a dedication to helping clients achieve their health goals.",
    "Writer with a talent for crafting engaging stories and persuasive content.",
    "Chef with a creative flair for crafting delicious and visually appealing dishes.",
    "Research scientist with expertise in data analysis and experimental design.",
    "Environmental activist with a mission to promote sustainability and protect our planet."
]
image_url = ['/data/user/0/com.example.app/app_flutter/c554c720-dc2d-11ed-a4e6-994d50c0ed5c.jpg','/data/user/0/com.example.app/app_flutter/8ce11270-dc48-11ed-b8fe-a9679b22c108.jpg','/data/user/0/com.example.app/app_flutter/00f8bcf0-ddaf-11ed-9863-e3c82020fa66.jpg']

# for i in range(100):

#     content = {}
#     content['name'] = f'{name[rd.randint(0,len(name)-1)]} {surnames[rd.randint(0,len(surnames)-1)]}'
#     content['email'] = f'test{i}@gmail.com'
#     content['password'] = 'password'
#     content['type'] = f'{type[rd.randint(0,len(type)-1)]}'

#     if content['type'] == "Homeowner":
#         content['image_url'] = f'{image_url[rd.randint(0,len(image_url)-1)]}'
#     else:
#         content['image_url'] = ""
#     content['location'] = f'{location[rd.randint(0,len(location)-1)]}'
#     content['likes'] = f'"{likes[rd.randint(0,len(likes)-1)]},{likes[rd.randint(0,len(likes)-1)]},{likes[rd.randint(0,len(likes)-1)]}"'
#     content['dislikes'] = f'"{dislikes[rd.randint(0,len(dislikes)-1)]},{dislikes[rd.randint(0,len(dislikes)-1)]},{dislikes[rd.randint(0,len(dislikes)-1)]}"'
#     content['bio'] = f'{bio[rd.randint(0,len(bio)-1)]}'
#     print(content)
#     res = requests.post('http://localhost:3000/auth/signup',json=content)
#     print(res.status_code)



import numpy as np

def rand_answers(randnums):
    string = ""
    for i in randnums:
        string+=f"{i},"
    return string[:len(string)-1]

for i in range(100):
    content = {}
    randnums1 = np.random.randint(1,6,6)
    randnums2 = np.random.randint(1,6,6)
    randnums3 = np.random.randint(1,6,6)
    randnums4 = np.random.randint(1,6,6)
    randnums5 = np.random.randint(1,6,6)
    num = i+1
    content['user_id'] = num
    content['data'] =  [rand_answers(randnums1),rand_answers(randnums2),rand_answers(randnums3),rand_answers(randnums4),rand_answers(randnums5)]
    print(content)

    res = requests.post('http://localhost:3000/kmeans',json=content)
    print(res.status_code)

    if res.status_code == 401:

        while res.status_code != 200:
            print(f'inside while {num}')
            randnums1 = np.random.randint(1,6,6)
            randnums2 = np.random.randint(1,6,6)
            randnums3 = np.random.randint(1,6,6)
            randnums4 = np.random.randint(1,6,6)
            randnums5 = np.random.randint(1,6,6)
            content['user_id'] = num
            content['data'] =  [rand_answers(randnums1),rand_answers(randnums2),rand_answers(randnums3),rand_answers(randnums4),rand_answers(randnums5)]
            res = requests.post('http://localhost:3000/kmeans',json=content)
            print(res.status_code)