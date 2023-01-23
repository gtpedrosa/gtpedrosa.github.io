+++
title = "Using SQLAlchemy to navigate an existing database"
author = ["Guilherme Pedrosa"]
date = 2019-04-06T18:56:00-03:00
tags = ["python", "ORM", "Databases"]
draft = false
+++

Given the task to interact with an existing database I felt compelled to use the ORM abstraction instead of making queries with raw sql. My aim was to avoid the common pitfalls regarding making text templates for sqlqueries, prone to sql injection exploits, and enhance query composability.

I've found there are essentialy two ways to approach this task: through reflection or a declarative model. Both approaches are explained in the following sections.


## SQLAlchemy reflection {#sqlalchemy-reflection}

Reflection uses metadata property to access schema constructs. It offers a few methods to access table objects, which do not have to be explicitly declared.

The downside of this approach is mantainability, since schema changes can make code unreliable. Here's an eample of how to access the _TimeStamp_ column of a _Table_I_Want_to_Interact_ in a generic database:

```python
  from sqlalchemy.orm import sessionmaker
  from sqlalchemy import create_engine, MetaData, Table

  # Using SQLAlchemy reflection example
  engine = create_engine('connectionstringhere')
  table1meta = MetaData(engine)
  table1 = Table('Table_I_Want_to_Interact', table1meta, autoload=True)
  DBSession = sessionmaker(bind=engine)
  session = DBSession()
  results = session.query(table1).filter(table1.columns.TimeStamp>="2019-02-26 18:00:00.000")
  results.all()
```


## SQLAlchemy declarative model {#sqlalchemy-declarative-model}

The declarative model needs Table objects to be explicitly declared. Due to this inherent verbose nature, I have found it is easier to grasp what is happening and even how the database is structured after a glance at the source code, such as in the following snippet:

```python
  from sqlalchemy import create_engine, MetaData, BigInteger, CHAR, Column, DateTime, Float, Integer, SmallInteger, String, Table, Unicode, text
  from sqlalchemy.ext.declarative import declarative_base
  from sqlalchemy.orm import sessionmaker

  Base = declarative_base()
  metadata = Base.metadata


  my_table_object = Table(
      'table_name', metadata,
      Column('Column1', Integer, nullable=False),
      Column('TimeStamp', DateTime, nullable=False),
      Column('Column3', Integer, nullable=False),
      Column('Column4', Unicode(2000))
  )
```

Here a table named _table_name_ in the database is being mapped to the _my_table_object_ instance. It should be noted that not all columns need to be mapped. Uninteresting columns can be left out with no drawbacks.

Depending on the database structure size, however,  it could be cumbersome to define multiple tables. For use cases like this, I have found the package [sqlacodegen](https://pypi.org/project/sqlacodegen/) of great help. It automates the task of creating the declarative models for you. Providing an output file and a connections tring it is as easy as issuing:

```shell
  sqlcodegen --outfile models.py mssql+pyodbc......
```

The resulting file can be easily imported and the this task promptly abstracted.
