

def func():
    import base64
    import json

    import requests

    api = 'http://127.0.0.1:8000/api/carriages/'
    image_file = 'photo_2021-12-03_12-57-48.thumbnail.jpg'

    with open(image_file, "rb") as f:
        im_bytes = f.read()
    im_b64 = base64.b64encode(im_bytes).decode("utf8")

    headers = {'Content-type': 'application/json'}

    payload = json.dumps({"cargo_weight": "1",
                          "carriage_number": "1",
                          "carriage_type": "1",
                          "carriage_photo": im_b64,
                          "quality_control": 23,
                          "train": 1,
                          })
    response = requests.post(api, data=payload, headers=headers)
    try:
        data = response.json()
        print(data)
    except requests.exceptions.RequestException:
        print(response.text)

if __name__ == '__main__':
    # func()
    import requests
    data = {
        'name_organization': 'Гречка3',
        'train_number': 2,
        'date': '2021-12-03',
    }
    import os
    path_img = 'photo_2021-12-03_12-57-48.thumbnail.jpg'
    path_img2 = 'photo_2021-12-03_12-57-48.thumbnail2.jpg'
    url = 'http://127.0.0.1:8000/api/test/'
    with open(path_img, 'rb') as img:

        with open(path_img2, 'rb') as img2:
            name_img2 = os.path.basename(path_img2)
            name_img = os.path.basename(path_img)
            files = {'carriage_photo': (name_img, img, 'multipart/form-data', {'Expires': '0'}),
                     'carriage_quality_photo': (name_img2, img2, 'multipart/form-data', {'Expires': '0'}),
                     }
            # data = {"cargo_weight": "5",
            #                   "carriage_number": "15",
            #                   "carriage_type": "2",
            #                   "quality_control": 80,
            #                   "train": "2",
            #                   }
            data = {
                'carriage': "1",
            }
            with requests.Session() as s:
                r = s.post(url, files=files, data=data)
                print(r.status_code)
    # data = {
    #     'name_organization': 'Гречка3',
    #     'train_number': 2,
    #     'date': '2021-12-03',
    # }
    # response = requests.post('http://127.0.0.1:8000/api/trains/', data=data)
    print('hello')
