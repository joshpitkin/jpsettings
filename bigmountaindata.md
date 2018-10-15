## Key note magic...
Arthur c Clark author



## Clean Architecture
Craig Berntson
@craigber
slidedeck.com/craigber


from book
- Bob Martin, Clean Architecture

structured programming, oop, functional programming
solid principles
can be applied anywhere

components - bundled functionality "box that doesn't care about it's arrows"

measure of architecture quality via component attributes:

component cohesion principles
open-closed principle
common closure principle
common reuse principle
- triangle 

a-cyclic dependencies principle (adp)
- dependencies don't loop back on each other
stable dependencies principle (sdp)
- some components are designed to be volatile
- if a component is difficult to change, it should not depend on a volatile component.
stable abstractions principle (sap)
- a component should be as abstract as it is stable


details are not part of architecture
design vs architecture
- exclude things that don't affect the function
architecture is the shape of a software system the form of that shape is the division of that system into components, the arrangement of those components, and the ways in which those components communicate with each other.

Purpose of Architecture - Minimize lifetime cost & maximize programmer productivity

Good Architecture Supports
- Use Cases
- Operation
- Development
- Deployment
- Leaves options open

Decouple your components

Business Rules -> Database Interface -/-> Database access -> Database
- seam enables change to db technology

Business Rules -/-> GUI
Business Rules -/-> Database

Details:
- Database
- Performance
- Web?
- Frameworks

jenkinsx

## Refactoring Katas: Training To Instinctively Improve Code - Gary Ray
@geekcyclist
Github: geekcyclist/utah-bmdd-2018
Xkcd/1698
A code kata is an exercise in programming which helps programmers hone their skills through practice and repetition.
Fizzbuzz  collatz conjecture
Refactoring kata- sub-set of code kata where the staring point is existing code with identifiable flaws rather than a clean slate with th specific goal of building the programmer’s ability to quickly read, understand and change existing code.
Legacy Code is.. 
Code maintained by an administrator that did not develop the code
I mean any production enterprise code older than a week – Alan Hemmings @snowcode
Any production code where the business value continues to outweigh the cost of maintenance.
Business Value – Technical Debt = Technical Net Worth
It’s working / providing value.
Refactoring by Martin Fowler
2nd edition has JS
Sparrow Decks
Relevant vs. Clutter code
Duplication vs Distinct code

The Core Refactorings
- Rename
- Inline
- Extract Method
- Introduce Local Varible
- Introduce Parameter
- Introduce Field

resharper
ask the ide - "refactor this"

more sparrow decks 
refactoring kata resources

TDD katas - roy osherove's
pair & mob
tiny changes
spaced repetition
create your own
keyboard shortcut kata
inline function, extract method - refactoring keyboard shortcuts


## Python APIs
github/chasedehan/big_mountain_2018

Why a rest api?
- unbundle machine learning from rest of tech stack
- allows to develop model and deploy in the same language
- doesn't restrict model selection

Process
1. Build and evaluate model perfromance
2. Save the model
3. Build Flask Application
  1. Load model
  2. Handle requests and return score
4. Call API from another service

Basics of building a ML Model
- Prep data
- Cross Validate predictions
- Train models
- Evaluate models

Demo
-pycharm
titanic - survived/died by pclass, sex, age
pandas get_dummies - splits categories into columnar t/f

## Because it's the connection that matters
- Michael Black
- Neo4J (graph database)

it's not enough anymore to just have the data, you have to be able to connect the data.
marriott, airfare bookings 99% on neo4j

common use cases
- ai & ML
- fraud detection
- identity & access
- knowledget graphs
- master data management
- ntwork & IT ops
- privacy & risk compliances
- recommendation engines
- social networks

what does graph data look like?
- there are nodes (verticies) and relationships (edges)
- rdms  data is still stored in tablular format

you model the same as you speak it
your nouns are your nodes
your verbs are your relationships
be wary of the pitfalls of lazy speech.  (emailed)
arrow tool - http://www.apcjones.com/arrows/

- speed comes from querying over relationships
schemaless flexibility

property graph model
nodes can have zero to many labels
relationships are always directional (but you can query without a direction specified)

when should the data be an attribute of a node or when do you make a node of the data and create a relationship
-- err on the side of making new nodes

queries are tuned for the traversal of nodes

schemaless, but it doesn't have to be the wild wild west - define constraints and indexes

you can define:
- unqiue constraints
- required attributes
- triggers
- indexes
- primary keys
