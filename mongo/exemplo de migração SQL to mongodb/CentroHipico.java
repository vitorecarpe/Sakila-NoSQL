/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package migracao;

/**
 *
 * @author goncalo
 */
import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.client.MongoDatabase;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class CentroHipico 
{
	public static void main(String[] args) throws ClassNotFoundException 
	{
		MongoClient mongo = new MongoClient("localhost",27017);
		MongoDatabase db = mongo.getDatabase("CentroHipico");
		
		Connection con = null;
		
		Migracao m = new Migracao(con, db);
		
                m.drop();
		m.migrateAluno();
                m.migrateInstrutor();
                m.migrateCavalo();
                m.migrateModalidade();
	
	}
}