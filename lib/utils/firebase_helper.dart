import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

String uid = auth.currentUser!.uid;

CollectionReference companiesCollection = firestore.collection('companies');
CollectionReference clientsCollection = firestore.collection('clients');
CollectionReference sitesCollection = firestore.collection('sites');
CollectionReference activitiesCollection = firestore.collection('activities');
CollectionReference bookingsCollection = firestore.collection('bookings');

Reference logosRef(String companyId) => storage.ref('logos/$companyId');
Reference picturesRef(String clientId) => storage.ref('pictures/$clientId');
Reference imagesRef(String entityId) => storage.ref(entityId);
