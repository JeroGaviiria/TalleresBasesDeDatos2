package com.mongo.Normalizado;

import com.mongodb.client.*;
import com.mongodb.client.model.Aggregates;
import static com.mongodb.client.model.Filters.*;
import java.util.Arrays;
import org.bson.Document;

/**
 *
 * @author jeron
 */
public class DetallePedidos {
    
     

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("parcial3");
        MongoCollection<Document> collection = database.getCollection("detalle_pedidos");
        System.out.println("CONEXION EXITOSA");
        
        
        CrudDetallePedidos crudDetallePedidos = new CrudDetallePedidos();
        
       
      // Crear detalle pedido
        crudDetallePedidos.crearDetallePedido("detalle001", "pedido001", "producto001", 2, 16.24);
        // Leer detalle pedido
        crudDetallePedidos.leerDetallePedido("detalle001");     
        // Listar detalle pedidos
        crudDetallePedidos.listarDetallePedidos();
        // Actualizar detalle pedido
        crudDetallePedidos.actualizarDetallePedido("detalle001",  5);
        // Eliminar detalle pedido
        crudDetallePedidos.eliminarDetallePedido("detalle001");

 
   // Obtener los pedidos en donde exista un detalle de pedido con el producto010
    AggregateIterable<Document> resultado = collection.aggregate(Arrays.asList(
            Aggregates.match(eq("producto_id", "producto010")),
            Aggregates.lookup("pedidos", "pedido_id", "_id", "pedido_detalle"),
            Aggregates.unwind("$pedido_detalle"),
            Aggregates.project(new Document("pedido", "$pedido_detalle"))));
    for (Document doc : resultado) {
        System.out.println(doc.toJson());
    }
        
             
    }
}

        
        
        
        
        



        