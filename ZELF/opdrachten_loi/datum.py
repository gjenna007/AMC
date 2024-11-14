from datetime import datetime
now = datetime.now() # current date and time
wkday = now.weekday()
year = now.strftime("%Y")
month = now.strftime("%m")
day = int(now.strftime("%d"))=
maanden=['januari','februari','maart','april','mei','juni','juli','augustus','september','oktober','november','december']
maand=maanden[int(month)-1]
weekdagen=['maandag','dinsdag','woensdag','donderdag','vrijdag','zaterdag','zondag']
weekdag=weekdagen[wkday]
print(f'Vandaag is het {weekdag} {day} {maand} {year}.')
