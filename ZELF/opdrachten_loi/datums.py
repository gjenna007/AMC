from datetime import datetime
def format_date (datestring):
    '''Convert a date string of the form "dd-mm-jjjj" to a datetime object'''
    #day=int(datestring[0:2])
    #month=int(datestring
    f="%d-%m-%Y"
    out = datetime.strptime(datestring, f)
    return out

date="24-10-1973"
a=format_date(date)
print(a)

