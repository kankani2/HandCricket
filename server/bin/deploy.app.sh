#!/bin/bash

mvn clean
mvn package

mvn appengine:deploy