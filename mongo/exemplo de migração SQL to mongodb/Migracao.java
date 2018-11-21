package migracao;

import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Migracao {

    private Connection con;
    private MongoDatabase db;

    public Migracao(Connection con, MongoDatabase db) {
        this.db = db;
        this.con = con;
    }

    public void migrateAluno() throws ClassNotFoundException {
        String nome = null, morada = null, email = null, localidade = null;
        int telemovel = 0;
        int nr = 0;
        String data = null;

        try {

            this.con = (Connection) Connect.connect();
            String sql = ""+ "Select A.Nome, A.Morada, A.DataNascimento, A.Email, A.Telefone, L.Designacao FROM Aluno AS A \n"
                    + "INNER JOIN Localidade AS L\n"
                    + "ON A.Localidade = L.Id\n";
            PreparedStatement ps = this.con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            MongoCollection<BasicDBObject> collection = this.db.getCollection("Aluno", BasicDBObject.class);

            while (rs.next()) {
                
                nome = rs.getString("A.Nome");
                morada = rs.getString("A.Morada");
                data = rs.getString("A.DataNascimento");
                email = rs.getString("A.Email");
                telemovel = rs.getInt("A.Telefone");
                localidade = rs.getString("L.Designacao");

                BasicDBObject document = new BasicDBObject();
                
                document.put("Nome", nome);
                document.put("Morada", morada);
                document.put("DataNascimento", data);
                document.put("Email", email);
                document.put("Telefone", telemovel);
                document.put("Localidade", localidade);
                collection.insertOne(document);
            }
        } catch (SQLException e) {
            System.out.printf(e.getMessage());
        } finally {
            try {
                Connect.close((java.sql.Connection) con);
            } catch (Exception e) {
                System.out.printf(e.getMessage());
            }
        }
    }

    
    public void migrateInstrutor() throws ClassNotFoundException{
        String nome = null, morada = null, email = null, localidade = null;
        int telemovel = 0;
        String data = null;

        try {

            this.con = (Connection) Connect.connect();
            String sql = ""+ "Select I.Nome, I.Morada, I.DataNascimento, I.Email, I.Telefone, L.Designacao from Instrutor AS I \n"
                    + "INNER JOIN Localidade AS L\n"
                    + "ON I.Localidade = L.Id\n";
            PreparedStatement ps = this.con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            MongoCollection<BasicDBObject> collection = this.db.getCollection("Instrutor", BasicDBObject.class);

            while (rs.next()) {
               
                nome = rs.getString("I.Nome");
                morada = rs.getString("I.Morada");
                data = rs.getString("I.DataNascimento");
                email = rs.getString("I.Email");
                telemovel = rs.getInt("I.Telefone");
                localidade = rs.getString("L.Designacao");

                BasicDBObject document = new BasicDBObject();
                
                document.put("Nome", nome);
                document.put("Morada", morada);
                document.put("DataNascimento", data);
                document.put("Email", email);
                document.put("Telefone", telemovel);
                document.put("Localidade", localidade);
                collection.insertOne(document);
            }
        } catch (SQLException e) {
            System.out.printf(e.getMessage());
        } finally {
            try {
                Connect.close((java.sql.Connection) con);
            } catch (Exception e) {
                System.out.printf(e.getMessage());
            }
        }
    }
    
    public void migrateCavalo() throws ClassNotFoundException{
        String nome = null, raça = null, coudelaria = null;
        int nrbox = 0;
        String data = null;

        try {

            this.con = (Connection) Connect.connect();
            String sql = ""+ "Select C.Nome, C.Raca, C.DataNascimento, C.Coudelaria, C.NrBox FROM Cavalo AS C \n";
            PreparedStatement ps = this.con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            MongoCollection<BasicDBObject> collection = this.db.getCollection("Cavalo", BasicDBObject.class);

            while (rs.next()) {
               
                nome = rs.getString("C.Nome");
                raça = rs.getString("C.Raca");
                data = rs.getString("C.DataNascimento");
                coudelaria = rs.getString("C.Coudelaria");
                nrbox = rs.getInt("C.NrBox");
               

                BasicDBObject document = new BasicDBObject();
                
                document.put("Nome", nome);
                document.put("Raca", raça);
                document.put("DataNascimento", data);
                document.put("Coudelaria", coudelaria);
                document.put("NrBox", nrbox);
                
                collection.insertOne(document);
            }
        } catch (SQLException e) {
            System.out.printf(e.getMessage());
        } finally {
            try {
                Connect.close((java.sql.Connection) con);
            } catch (Exception e) {
                System.out.printf(e.getMessage());
            }
        }
    }
    
    
    
    public void migrateModalidade() throws ClassNotFoundException{
        
        String nomeMod = null, descriçao = null;
        int nvldificuldade;
                
        String datanascimento = null, nomeInst = null, email = null, morada = null, localidade = null;
        int telefone;
        
        String nomeCav = null, raça = null, coudelaria = null, dataCav = null;
        int nrbox = 0;
        
        
        try{
            con = Connect.connect();
            PreparedStatement ps = con.prepareStatement("" + "SELECT * FROM Modalidade\n");
            ResultSet rs = ps.executeQuery();
            MongoCollection<BasicDBObject> collection = this.db.getCollection("Modalidade",BasicDBObject.class);
            
            while(rs.next()){
                 
                 nomeMod = rs.getString("Nome");
                 descriçao = rs.getString("Descricao");
                 nvldificuldade = rs.getInt("NvlDificuldade");
                 BasicDBObject doc = new BasicDBObject();
                 
                 doc.put("Nome",nomeMod);
                 doc.put("Descricao",descriçao);
                 doc.put("NvlDificuldade",nvldificuldade);
                 
                 PreparedStatement ps2 = con.prepareStatement(""
                 + "SELECT I.Nome, I.Morada, I.DataNascimento, I.Email, I.Telefone, L.Designacao FROM Instrutor AS I \n"
                 + "INNER JOIN Localidade AS L \n"
                 + "ON I.Localidade = L.Id \n"
                 + "WHERE Modalidade = ?");
                 
                 
                 ps2.setString(1, nomeMod);
                 ResultSet rs2 = ps2.executeQuery();
                 BasicDBList lista = new BasicDBList();
                 
                 while(rs2.next()){
                     nomeInst = rs2.getString("I.Nome");
                     datanascimento = rs2.getString("I.DataNascimento");
                     email = rs2.getString("I.Email");
                     telefone = rs2.getInt("I.Telefone");
                     morada = rs2.getString("I.Morada");
                     localidade = rs2.getString("L.Designacao");
                     
                     BasicDBObject docInstrutor = new BasicDBObject ();
                     
                     docInstrutor.put("Nome",nomeInst);
                     docInstrutor.put("DataNascimento",datanascimento);
                     docInstrutor.put("Email", email);
                     docInstrutor.put("Telefone", telefone);
                     docInstrutor.put("Morada", morada);
                     docInstrutor.put("Localidade",localidade);
                     
                     lista.add(docInstrutor);
                     
                     
                 }
                 
                 doc.put("Instrutores",lista);
                 
                 PreparedStatement ps3 = con.prepareStatement(""
                 + "SELECT * FROM Cavalo AS C WHERE Modalidade = ?");
                 
                 ps3.setString(1, nomeMod);
                 ResultSet rs3 = ps3.executeQuery();
                 BasicDBList listaCavalos = new BasicDBList();
                 
                 while(rs3.next()){
                     nomeCav = rs3.getString("C.Nome");
                     raça = rs3.getString("C.Raca");
                     dataCav = rs3.getString("C.DataNascimento");
                     coudelaria = rs3.getString("C.Coudelaria");
                     nrbox = rs3.getInt("C.NrBox");
                     
                     BasicDBObject docCavalos = new BasicDBObject();
                     
                     docCavalos.put("Nome", nomeCav);
                     docCavalos.put("Raca", raça);
                     docCavalos.put("DataNascimento",dataCav);
                     docCavalos.put("Coudelaria", coudelaria);
                     docCavalos.put("NrBox", nrbox);
                     listaCavalos.add(docCavalos);
                 }
                 
                 doc.put("Cavalos",listaCavalos);
                 collection.insertOne(doc);
                
            }
        }
        catch(SQLException e)
        {
            System.out.printf(e.getMessage());
        }
        finally
        {
            try{
                Connect.close(con);
            }
            catch(Exception e)
            {
                System.out.printf(e.getMessage());
            }
        }
        
    }
    
    public void migrateInscricao() throws ClassNotFoundException
    {
        String dataInicio = null, dataFim = null;
        int nrAulas = 0, preco = 0;
        int idAluno = 0;
        
        String nome = null, morada = null, email = null, localidade = null;
        int telemovel = 0;
        String data = null;
        
        String modalidade = null;
        int nivel = 0;
        String descricao = null;
        
        String datanascimento = null, nomeInst = null, emailInst = null, moradaInst = null, localidadeInst = null;
        int telefone;
        
        String nomeCav = null, raça = null, coudelaria = null, dataCav = null;
        int nrbox = 0;
        
        try{
                con = Connect.connect();
                PreparedStatement ps = con.prepareStatement("" + "SELECT * FROM Inscricao\n");
                ResultSet rs = ps.executeQuery();
                MongoCollection<BasicDBObject> collection = this.db.getCollection("Inscricao",BasicDBObject.class);

                while(rs.next())
                {

                     dataInicio = rs.getString("DataInicio");
                     dataFim = rs.getString("DataFim");
                     nrAulas = rs.getInt("NrDeAulas");
                     preco = rs.getInt("Preco");
                     
                     idAluno = rs.getInt("Aluno");
                     BasicDBObject doc = new BasicDBObject();

                     doc.put("DataInicio",dataInicio);
                     doc.put("DataFim",dataFim);
                     doc.put("NrAulas",nrAulas);
                     doc.put("Preco", preco);
                     
    
                     PreparedStatement ps2 = con.prepareStatement(""
                        + "select A.Nome, A.DataNascimento, A.Email, A.Morada, A.Telefone, L.Designacao, I.Modalidade from Aluno As A \n"
                        + "inner join Inscricao as I \n"
                        + "inner join Localidade as L\n"
                        + "where I.Aluno = A.Nr and A.Localidade = L.Id and I.Aluno = ?");
                 
                    
                        ps2.setInt(1, idAluno);
                        ResultSet rs2 = ps2.executeQuery();
                        
                    while(rs2.next())
                    {    
                        nome = rs2.getString("A.Nome");
                        morada = rs2.getString("A.Morada");
                        data = rs2.getString("A.DataNascimento");
                        email = rs2.getString("A.Email");
                        telemovel = rs2.getInt("A.Telefone");
                        localidade = rs2.getString("L.Designacao");
                        modalidade = rs2.getString("I.Modalidade");

                        BasicDBObject docAluno = new BasicDBObject();
                
                        docAluno.put("Nome", nome);
                        docAluno.put("Morada", morada);
                        docAluno.put("DataNascimento", data);
                        docAluno.put("Email", email);
                        docAluno.put("Telefone", telemovel);
                        docAluno.put("Localidade", localidade);
                        
                        doc.put("Aluno",docAluno);
                    }       
                          
                        PreparedStatement ps3 = con.prepareStatement(""
                        + "Select M.Nome, M.NvlDificuldade, M.Descricao from Modalidade As M\n" 
                        +"where M.Nome = ?");
                        ps3.setString(1,modalidade);
                        ResultSet rs3 = ps3.executeQuery();
                        BasicDBObject mod = new BasicDBObject();
                        
                        while(rs3.next())
                        {
                            nivel = rs3.getInt("M.NvlDificuldade");
                            descricao = rs3.getString("M.Descricao");
                        
                            mod.put("Nome", modalidade);
                            mod.put("Nivel", nivel);
                            mod.put("Descricao", descricao);
                        
                            doc.put("Modalidade",mod); 
                        
                        }
               
                
                 PreparedStatement ps4 = con.prepareStatement(""
                 + "SELECT I.Nome, I.Morada, I.DataNascimento, I.Email, I.Telefone, L.Designacao FROM Instrutor AS I \n"
                 + "INNER JOIN Localidade AS L \n"
                 + "ON I.Localidade = L.Id \n"
                 + "WHERE Modalidade = ?");
                 
                 
                 ps4.setString(1, modalidade);
                 ResultSet rs4 = ps4.executeQuery();
                 BasicDBList lista = new BasicDBList();
                 
                 while(rs4.next()){
                     nomeInst = rs4.getString("I.Nome");
                     datanascimento = rs4.getString("I.DataNascimento");
                     emailInst = rs4.getString("I.Email");
                     telefone = rs4.getInt("I.Telefone");
                     moradaInst = rs4.getString("I.Morada");
                     localidadeInst = rs4.getString("L.Designacao");
                     
                     BasicDBObject docInstrutor = new BasicDBObject ();
                     
                     docInstrutor.put("Nome",nomeInst);
                     docInstrutor.put("DataNascimento",datanascimento);
                     docInstrutor.put("Email", emailInst);
                     docInstrutor.put("Telefone", telefone);
                     docInstrutor.put("Morada", moradaInst);
                     docInstrutor.put("Localidade",localidadeInst);
                     
                     lista.add(docInstrutor);
                     
                     
                 }
                 
                 doc.put("Instrutores",lista);
                 
                 PreparedStatement ps5 = con.prepareStatement(""
                 + "SELECT * FROM Cavalo AS C WHERE Modalidade = ?");
                 
                 ps5.setString(1, modalidade);
                 ResultSet rs5 = ps5.executeQuery();
                 BasicDBList listaCavalos = new BasicDBList();
                 
                 while(rs5.next())
                 {
                     nomeCav = rs5.getString("C.Nome");
                     raça = rs5.getString("C.Raca");
                     dataCav = rs5.getString("C.DataNascimento");
                     coudelaria = rs5.getString("C.Coudelaria");
                     nrbox = rs5.getInt("C.NrBox");
                     
                     BasicDBObject docCavalos = new BasicDBObject();
                     
                     docCavalos.put("Nome", nomeCav);
                     docCavalos.put("Raca", raça);
                     docCavalos.put("DataNascimento",dataCav);
                     docCavalos.put("Coudelaria", coudelaria);
                     docCavalos.put("NrBox", nrbox);
                     listaCavalos.add(docCavalos);
                 }
                 
                 doc.put("Cavalos",listaCavalos);
                 collection.insertOne(doc);
                  
                }

            }
            catch(SQLException e)
            {
                System.out.printf(e.getMessage());
            }
            finally
            {
                try
                {
                    Connect.close(con);
                }
                catch(Exception e)
                {
                     System.out.printf(e.getMessage());
                }
            }
    }
    
    public void drop ()
    {
        MongoCollection<BasicDBObject> collection = this.db.getCollection("Instrutor",BasicDBObject.class);
        collection.drop();
        collection = this.db.getCollection("Aluno", BasicDBObject.class);
        collection.drop();
        collection = this.db.getCollection("Cavalo", BasicDBObject.class);
        collection.drop();
        collection = this.db.getCollection("Modalidade", BasicDBObject.class);
        collection.drop();
        collection = this.db.getCollection("Inscricao", BasicDBObject.class);
        collection.drop();
    }
    
}
