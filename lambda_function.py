import boto3
import operator
import os

logs = boto3.client('logs')

def lambda_handler(event, context):
    print(event)
    fetched_log_groups = []
    logs_to_tag = []

    try:
        logs_to_tag.append(event['detail']['requestParameters']['logGroupName'])
    except:
        fetched_log_groups = fetch_log_groups(logs) #fetching all log groups
        logs_to_tag = isTagged(logs, fetched_log_groups) #check whther the log group is tagged

    env = os.environ['ENV'] #to get the right account environment

    tag_log_groups(logs, logs_to_tag, env) #tag the untagged log groups



def fetch_log_groups (client): #getting all the log groups
    log_groups = []
    extra_args = {}

    try:
        while True:
            response = logs.describe_log_groups(**extra_args) #Fetch all log groups
            log_groups = log_groups + response['logGroups']

            if not 'nextToken' in response:
                break
            extra_args['nextToken'] = response['nextToken']

        return log_groups

    except NameError:
        raise Exception("Invalid Parameter Exception",client.exceptions.InvalidParameterException)
    except:
        raise Exception("The Service is unavailable ",client.exceptions.ServiceUnavailableException)


def isTagged(client, log_groups): #getting the list of untagged groups
    untagged_groups = []
    try:
        for log in log_groups:
            log_Name = log['logGroupName']
            try:
                client.list_tags_log_group(logGroupName=log_Name)['tags']['Environment'] #check if environment exists
            except:
                untagged_groups.append(log_Name) #adding all untagged groups

        return untagged_groups  

    except NameError:
        raise Exception("Resource Not Found Exception",client.exceptions.ResourceNotFoundException)
    except:
        raise Exception("The Service is unavailable ",client.exceptions.ServiceUnavailableException)


#check the environment tag from the log group and apply the tag
#otherwise if there is no tag env on the log group, apply the default tag (sit)
def tag_log_groups(client, untagged_groups, env):
    ignored_groups = []
    try:
        for log_group in untagged_groups: 
            if operator.contains(log_group, "retail") and operator.contains(log_group, env):
                client.tag_log_group(logGroupName=log_group, tags={ 'Environment': env +'-retail', 'Project': 'SA Digital', 'Name': 'sadigital', 'TaggedBy': 'Lambda_Function'})
            elif operator.contains(log_group, env):
                client.tag_log_group(logGroupName=log_group, tags={ 'Environment': env,'Project': 'SA Digital', 'Name': 'sadigital', 'TaggedBy': 'Lambda_Function'})
            else:
                ignored_groups.append( log_group)

        print("ignored_groups : %s" % ignored_groups)
    except NameError:
        raise Exception("Invalid Parameter Exception: ",client.exceptions.InvalidParameterException)
    except:
        raise Exception("Resource Not Found Exception: ",client.exceptions.ResourceNotFoundException)
    
    
    
    