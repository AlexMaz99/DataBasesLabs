
## ETCD LAB 

A distributed, reliable key-value store for the most critical data of a distributed system.  
Homepage: https://etcd.io/

Key features:

- Simple: well-defined, user-facing API (gRPC)
- Secure: automatic TLS with optional client cert authentication
- Fast: benchmarked 10,000 writes/sec
- Reliable: properly distributed using Raft


There are two major use cases: concurrency control in the distributed system and application configuration store. For example, CoreOS Container Linux uses etcd to achieve a global semaphore to avoid that all nodes in the cluster rebooting at the same time. Also, Kubernetes use etcd for their configuration store.

During this lab we will be using etcd3 python client.  
Homepage: https://pypi.org/project/etcd3/

```python
etcdCreds = { } # credentials deleted
```


```python
!pip install etcd3
```

    Requirement already satisfied: etcd3 in /opt/conda/envs/Python36/lib/python3.6/site-packages (0.12.0)
    Requirement already satisfied: six>=1.12.0 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (1.12.0)
    Requirement already satisfied: protobuf>=3.6.1 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (3.6.1)
    Requirement already satisfied: grpcio>=1.27.1 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (1.28.1)
    Requirement already satisfied: tenacity>=6.1.0 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (6.2.0)
    Requirement already satisfied: setuptools in /opt/conda/envs/Python36/lib/python3.6/site-packages (from protobuf>=3.6.1->etcd3) (40.8.0)


### How to connect to etcd using certyficate (part 1: prepare file with certificate)


```python
import base64
import tempfile

etcdHost = etcdCreds["connection"]["grpc"]["hosts"][0]["hostname"]
etcdPort = etcdCreds["connection"]["grpc"]["hosts"][0]["port"]
etcdUser = etcdCreds["connection"]["grpc"]["authentication"]["username"]
etcdPasswd = etcdCreds["connection"]["grpc"]["authentication"]["password"]
etcdCertBase64 = etcdCreds["connection"]["grpc"]["certificate"]["certificate_base64"]
                           
etcdCertDecoded = base64.b64decode(etcdCertBase64)
etcdCertPath = "{}/{}.cert".format(tempfile.gettempdir(), etcdUser)
                           
with open(etcdCertPath, 'wb') as f:
    f.write(etcdCertDecoded)

print(etcdCertPath)
```

    /home/dsxuser/.tmp/ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46.cert


### Short Lab description

During the lab we will simulate system that keeps track of logged users
- All users will be stored under parent key (path): /logged_users
- Each user will be represented by key value pair
    - key /logged_users/name_of_the_user
    - value hostname of the machine (e.g. name_of_the_user-hostname)

### How to connect to etcd using certyficate (part 2: create client)


```python
import etcd3

etcd = etcd3.client(
    host=etcdHost,
    port=etcdPort,
    user=etcdUser,
    password=etcdPasswd,
    ca_cert=etcdCertPath
)

cfgRoot='/logged_users'
```

### Task1 : Fetch username and hostname

define two variables
- username name of the logged user (tip: use getpass library)
- hostname hostname of your mcomputer (tip: use socket library)


```python
import getpass
import socket

username = "AMazur"  # You can put your name here, while this code is run in the container and user name would be same for all students
hostname = socket.gethostname()

userKey='{}/{}'.format(cfgRoot, username)
userKey, '->', hostname

etcd.put(userKey, hostname)
```




    header {
      cluster_id: 17394822126184162018
      member_id: 17586574424884576738
      revision: 315870
      raft_term: 3204
    }



### Task2 : Register number of users 

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

for all names in table fixedUsers register the appropriate key value pairs


```python
fixedUsers = [
    'Adam',
    'Borys',
    'Cezary',
    'Damian',
    'Emil',
    'Filip',
    'Gustaw',
    'Henryk',
    'Ignacy',
    'Jacek',
    'Kamil',
    'Leon',
    'Marek',
    'Norbert',
    'Oskar',
    'Patryk',
    'Rafał',
    'Stefan',
    'Tadeusz'
]

for user in fixedUsers:
    userKey='{}/{}'.format(cfgRoot, user)
    etcd.put(userKey, hostname)

```

### Task3: List all users

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

List all registered user (tip: use common prefix)


```python
for key in etcd.get_prefix(cfgRoot):
    print(key)
```

    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36933951faff2f46449720793983297309-5f4ln4v', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36fd46088b0ef240789f6dc151c1df28e0-7ckrd6p', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py362d5e52f7d9fc4a24a46795ea3783b0c6-6dsht55', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'notebook-condafree1py36d4720f40a6d242a0b93099c0882a794a-7bvckh7', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'temporary', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7feda0a9c908>)
    (b'2', <etcd3.client.KVMetadata object at 0x7feda0a95eb8>)
    (b'somevalue', <etcd3.client.KVMetadata object at 0x7feda0a9c9b0>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7feda0a9c908>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7feda0a9c908>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7feda0a9c908>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7feda0a9c908>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7feda0a9c908>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36e38f78dbb72f42428025b7fc3d0c5819-6fwqqhq', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'user-toRefresh', <etcd3.client.KVMetadata object at 0x7feda0a9c3c8>)
    (b'notebook-condafree1py36f0d86649c9624b59a61d942f97342b42-64fspjq', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)


### Task 4 : Same as Task2, but use transaction

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

for all names in table fixedUsers register the appropriate key value pairs, use transaction to make it a single request  
(Have you noticed any difference in execution time?)


```python
etcd.transaction(
        compare=[etcd.transactions.version(cfgRoot) == 0],
        success=[etcd.transactions.put('{}/{}'.format(cfgRoot, user), 'user-{}'.format(user)) for user in fixedUsers],
        failure=[etcd.transactions.put('/tmp/failure', 'condtion failed')]
    )
```




    (False, [response_put {
        header {
          revision: 315914
        }
      }])



### Task 5 : Get single key (e.g. status of transaction)

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

Check the key you are modifying in on-failure handler in previous task


```python
for i in etcd.get_prefix('/tmp/failure'):
    print(i)
```

    (b'condtion failed', <etcd3.client.KVMetadata object at 0x7feda0a9cbe0>)


### Task 6 : Get range of Keys (Emil -> Oskar) 

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

- Get range of keys
- Is it inclusive / exclusive?
- Sort the resposne descending
- Sort the resposne descending by value not by key


```python
for key in etcd.get_range('{}/{}'.format(cfgRoot, 'Emil'), '{}/{}'.format(cfgRoot, 'Oskar'), sort_order='descend', sort_target='value'):
    print(key)
```

    (b'user-3-Norbert', <etcd3.client.KVMetadata object at 0x7feda0a9cdd8>)
    (b'user-3-Marek', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'user-3-Leon', <etcd3.client.KVMetadata object at 0x7feda0a9cdd8>)
    (b'user-3-Kamil', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'user-3-Jacek', <etcd3.client.KVMetadata object at 0x7feda0a9cdd8>)
    (b'user-3-Ignacy', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'user-3-Henryk', <etcd3.client.KVMetadata object at 0x7feda0a9cdd8>)
    (b'user-3-Gustaw', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'user-3-Filip', <etcd3.client.KVMetadata object at 0x7feda0a9cdd8>)
    (b'user-3-Emil', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'notebook-condafree1py36fd46088b0ef240789f6dc151c1df28e0-7ckrd6p', <etcd3.client.KVMetadata object at 0x7feda0a9cdd8>)
    (b'notebook-condafree1py36933951faff2f46449720793983297309-5f4ln4v', <etcd3.client.KVMetadata object at 0x7feda0a9c320>)
    (b'7', <etcd3.client.KVMetadata object at 0x7feda0a9cdd8>)


### Task 7: Atomic Replace

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

Do it a few times, check if value has been replaced depending on condition


```python
etcd.transaction(
        compare=[],
        success=[etcd.transactions.put('{}/{}'.format(cfgRoot, 'Oskar'), 'user-{}'.format('Oskar'))],
        failure=[]
    )

for _ in range(5):
    print(etcd.replace('{}/{}'.format(cfgRoot, 'Oskar'), 'user-{}'.format('Oskar'), "newOskar"))
```

    True
    False
    False
    False
    False


### Task 8 : Create lease - use it to create expiring key

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

You can create a key that will be for limited time
add user that will expire after a few seconds

Tip: Use lease



```python
import time

lease = etcd.lease(ttl=5)
etcd.put('{}/{}'.format(cfgRoot, 'leaseUser'), 'user-{}'.format('leaseUser'), lease=lease)

print(lease.remaining_ttl)
print(etcd.get('{}/{}'.format(cfgRoot, 'leaseUser')))

time.sleep(6)

print(lease.remaining_ttl)
print(etcd.get('{}/{}'.format(cfgRoot, 'leaseUser')))
```

    4
    (b'user-leaseUser', <etcd3.client.KVMetadata object at 0x7feda0ab8748>)
    -1
    (None, None)


### Task 9 : Create key that will expire after you close the connection to etcd

Tip: use threading library to refresh your lease


```python
import threading

lease = etcd.lease(ttl=6)

def refresh_lease():
    while(True):
        lease.refresh()
        time.sleep(1)

etcd.put('{}/{}'.format(cfgRoot, 'tmpUser'), 'user-{}'.format('tmpUser'), lease=lease)

t = threading.Thread(target=refresh_lease)
t.start()

print(etcd.get('{}/{}'.format(cfgRoot, 'tmpUser')))
time.sleep(10)
print(etcd.get('{}/{}'.format(cfgRoot, 'tmpUser')))
```

    (b'user-tmpUser', <etcd3.client.KVMetadata object at 0x7feda0ab8d30>)
    (b'user-tmpUser', <etcd3.client.KVMetadata object at 0x7feda0ab8dd8>)


### Task 9: Use lock to protect section of code

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html


```python
# it was tested with friends and it works

import time

with etcd.lock('lock-2', ttl=20) as lock:
    print('test1')
    print(f'Is acquaired? {lock.is_acquired()}')
    lock.acquire()
    print('test2')
    time.sleep(3)
    print('test3')
    lock.release()
```

    test1
    Is acquaired? True
    test2
    test3


### Task 10 Watch key

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

This cell will lock this notebook on waiting  
After running it create a new notebook and try to add new user


```python
# it was tested with friend, one of them was inserting values
def etcd_call(callback):
    print(callback)

etcd.add_watch_callback(key='/lease/watch/friends', callback=etcd_call)
```




    1



    <etcd3.watch.WatchResponse object at 0x7fedb8145320>
    <etcd3.watch.WatchResponse object at 0x7fedb8145320>
    <etcd3.watch.WatchResponse object at 0x7fedb8145320>


