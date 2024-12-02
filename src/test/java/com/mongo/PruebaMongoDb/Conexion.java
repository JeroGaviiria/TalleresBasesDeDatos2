package com.mongo.PruebaMongoDb;

import com.mongodb.client.*;
import static com.mongodb.client.model.Filters.*;
import java.util.Arrays;
import org.bson.Document;

/**
 *
 * @author jeron
 */
public class Conexion {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("pruebas");
        MongoCollection<Document> collection = database.getCollection("usuarios");
        System.out.println("CONEXION EXITOSA");
        
        Document documento = new Document("nombre", "Juan Perez").append("edad", 25);
        collection.insertOne(documento);    
        System.out.println("Documento insertado exitosamente");
        
        //INSERTAR VARIOS REGISTROS
       /* Document documento1 = new Document("nombre", "Jero Gaviria").append("edad", 25);
        Document documento2 = new Document("nombre", "Ana Gomez").append("edad", 30);
        Document documento3 = new Document("nombre", "Luis Torres").append("edad", 28);
        collection.insertMany(Arrays.asList(documento1, documento2, documento3));
        System.out.println("Documentos insertados exitosamente");*/

        //BUSCAR UN DOCUMENTO POR CAMPO
       /*Document documento = collection.find(eq("nombre", "Juan Perez")).first();
        if (documento != null) {
                String nombre = documento.getString("nombre");
                int edad = documento.getInteger("edad");
                System.out.println("Nombre: " + nombre + ", Edad: " + edad);
         } */
    FindIterable<Document> documentos = collection.find();
    for (Document doc : documentos) {
        String nombre = doc.getString("nombre");
        int edad = doc.getInteger("edad");
        System.out.println("Nombre: " + nombre + ", Edad: " + edad);
    }


    
    //CONSULTA DE DOCUMENTOS CON FILTROS
    //MongoCursor<Document> cursor = collection.find(and(eq("ciudad", "MADRID"), gt("edad", 19), lt("edad", 30))).iterate;
}
}