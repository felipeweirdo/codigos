USING System.Net.*.

DEFINE VARIABLE oFtp            AS System.Net.FtpWebRequest NO-UNDO.
DEFINE VARIABLE oStream         AS System.IO.Stream NO-UNDO.
DEFINE VARIABLE bfile           AS "System.Byte[]" NO-UNDO.
DEFINE VARIABLE response        AS System.Net.FtpWebResponse NO-UNDO.
DEFINE VARIABLE responseStream  AS System.IO.Stream NO-UNDO.
DEFINE VARIABLE Reader          AS System.IO.StreamReader NO-UNDO.

DEFINE VARIABLE OP_Directorio AS LONGCHAR NO-UNDO.



PROCEDURE Descarga.
DEFINE INPUT PARAMETER p_FTP     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_Usuario AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_Pass    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_archivo AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_path    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_respuesta AS LONGCHAR NO-UNDO.


    DEFINE VARIABLE cFile AS System.Net.WebClient.
      
    cFile = NEW System.Net.WebClient().
    
    cfile:Credentials = NEW System.Net.NetworkCredential(p_Usuario,p_Pass).
    
    cfile:DownloadFile(p_FTP + "/" + p_archivo, p_path + "\" + p_archivo).

    DELETE OBJECT cFile.
END.



PROCEDURE ListaArchivos.
DEFINE INPUT PARAMETER p_FTP     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_Usuario AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_Pass    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_respuesta AS LONGCHAR NO-UNDO.

/*Obtiene Archivos de FTP ***/
    oFtp = CAST(System.Net.WebRequest:Create(p_FTP), System.Net.FtpWebRequest).
    oFtp:Credentials = NEW System.Net.NetworkCredential(p_Usuario,p_Pass).
    oFtp:Method = System.Net.WebRequestMethods+Ftp:ListDirectory.           
    response =  CAST(oFtp:GetResponse(), System.Net.FtpWebResponse).         
    responseStream = response:GetResponseStream().
      
    Reader = NEW System.IO.StreamReader(responseStream).
    
    DO WHILE Reader:Peek() <> - 1:
        /*MESSAGE reader:ReadLine() VIEW-AS ALERT-BOX.*/
        OP_Respuesta = IF OP_Respuesta = "" THEN reader:ReadLine() ELSE  OP_respuesta + CHR(10) + reader:ReadLine() .
        
    END.       
    
    response:Close().       
END.
