#!/bin/bash

# Create the database and user
use test
db.createUser({
    user: "test",
    pwd: "test",
    roles: [
        {
            role: "readWrite",
            db: "test"
        }
    ]
})

# Connection string 
# mongodb://test:test@mongo:27017/test
