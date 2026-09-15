Prerequisites. International Airport 
The Airport Database is designed to manage various aspects of airport operations including passenger bookings, flights, airlines, and booking details. 
It's assumed that you've booked a flight online at least once, so the structure should be familiar. 
However, it's much simpler than a real-world database of this kind. 
 
 
International airport has main table, that stores data related to airports such as airport id, airport_name, country, state, city. Also, indicates the airport information when it’s created and updated. 
Airport stores information about scheduled and actual flights information. Attributes include flight id, departing gate, arriving gate, when flights created and updated at, airline id, departure airport id and arrival airport id, scheduled departure time, scheduled arrival time, actual departure time, actual arrival time. Flights are belonged to different airlines companies, that records information include airline id, airline code, name, country, and when airlines are created and updated. 
Each flight has bookings made by passengers. Attributes include booking id, flight id, status, booking platform, when booking is created and updated at, ticket price, and passenger id. If any changes appear in booking flight, that information should be store in a separate table. 
System collects details of boarding passes issued to passengers. Includes boarding pass id, seat, boarding time, when passes created and updated, and booking id. 
During booking of flights passengers, also must register baggage (if they have it). For each baggage system should keep baggage id, weight in kg, created date, updated date, and booking id. After registering of baggage, in airport each baggage which is belongs to booking, needs to be checked, and then collect information such as baggage checking id, check results, created at and updated at, booking id, and passenger id. 
System stores passenger information associated with bookings. Attributes include passenger id, first name, last name, gender, date of birth, country of citizenship, country of residence, passport number, when profile is created at and updated at. 
Also, each passenger passes airport security, and then details on security check collects information such as security check id, check results, when information created at and updated at, passenger id. 


For drawing ER-Diagram you must perform the following tasks: 
 
1 Identify Entities: Make a list of all the entities mentioned in the system description. 
2 Determine Attributes: For each entity, list down their attributes. Ensure to include primary keys, foreign keys, and any unique or required attributes, identify data types of each attribute. 
3 Identify Relationships: Review the system description and determine the relationships between entities. Pay attention to the cardinality (one-to-one, one-to-many, many-to-many) and participation constraints. 
4 raw Entity Boxes: Use a diagramming tool to create a box for each entity identified. Label each box with the entity name. 
5 Add Attributes: Inside each entity box, list the attributes identified for that entity. Include primary keys and any necessary foreign keys. 
6 Connect Entities with Relationships: Draw lines between related entities to represent their relationships. Label the lines with the appropriate cardinality and participation constraints. 
7 Document the Diagram: Provide a key or legend to explain any symbols or notations used in the diagram. Write a brief description or key explaining the meaning of each entity, attribute, and relationship. 