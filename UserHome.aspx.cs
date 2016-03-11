using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserHome : System.Web.UI.Page
{
    protected string ConnectionString = ConfigurationManager.ConnectionStrings["Connection"].ConnectionString;
    protected string UserID;
    protected string UserName;
    protected string UserType;
    protected Int64 Capacity;
    protected Int64 UsedSpace;

    protected void Page_Load(object sender, EventArgs e)
    {
        // some variables in this page are accessed in .aspx file, hence this method is called
        DataBind();

        if ((string)Session["current"] != "running" && Request.Cookies["UserInfo"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        else if ((string)Session["current"] == "running")
        {
            UserID = Session["userid"].ToString();
        }
        else if (Request.Cookies["UserInfo"] != null)
        {
            UserID = Request.Cookies["UserInfo"]["userid"];
            Session["current"] = "running";
            Session["userid"] = UserID;
        }

        using (SqlConnection Connection = new SqlConnection(ConnectionString))
        {
            Connection.Open();
            string commandString = "SELECT name, capacity, usedspace, usertype FROM UserInfo WHERE userid='" + UserID + "'";
            try
            {
                SqlCommand Command = new SqlCommand(commandString, Connection);
                SqlDataReader Reader = Command.ExecuteReader(CommandBehavior.CloseConnection);
                Reader.Read();
                UserName = Reader["name"].ToString();
                UsedSpace = Int64.Parse(Reader["usedspace"].ToString());
                Capacity = Int64.Parse(Reader["capacity"].ToString());
                UserType = Reader["usertype"].ToString();

            }
            catch (Exception E)
            {
                NameLabel.Text = "ERROR: Login Failed!<br />User not found or User may have been deleted by Administrator" + E.StackTrace;
            }
        }


        if (!IsPostBack)
        {
            SetSummary();
            Tab1.CssClass = "Clicked";
            Tab2.CssClass = "Initial";
            Tab3.CssClass = "Initial";

            SummaryPanel.Visible = true;
            MyFilesPanel.Visible = false;
            UploadPanel.Visible = false;
            TrashPanel.Visible = false;
        }
    }
    private void UpdateUsedspace(Int64 FileSize)
    {
        using (SqlConnection Connection = new SqlConnection(ConnectionString))
        {
            Connection.Open();
            string CommandString = "UPDATE UserInfo SET usedspace=" + (UsedSpace + FileSize) + " WHERE userid='" + UserID + "'";
            SqlCommand Command = new SqlCommand(CommandString, Connection);

            try
            {
                Command.ExecuteNonQuery();
            }
            catch (SqlException E)
            {
                StatusLabel.Text = "<font color=red>CRITICAL ERROR: in method UpdateUserInfoTable()</font><br />" + E.StackTrace;
            }
        }
    }
    private void SetSummary()
    {
        using (SqlConnection Connection = new SqlConnection(ConnectionString))
        {
            Connection.Open();

            SqlCommand Command = new SqlCommand(String.Format("SELECT COUNT(*) FROM Files WHERE userid='{0}'", UserID), Connection);
            FilesCountLabel.Text = Command.ExecuteScalar().ToString();

            Command.CommandText = String.Format("SELECT COUNT(*) FROM Files WHERE userid='{0}' and filepath='trash'", UserID);
            TrashFilesCountLabel.Text = Command.ExecuteScalar().ToString();
        }
        NameLabel.Text = "Hi, <span class=\"small-caps\">" + UserName + "!</span>";

        UserTypeLabel.Text = UserType;

        TotalSpaceLabel.Text = String.Format("{0} GB", (double)Capacity / 1073741824);

        if (UsedSpace >= 1048576)
            UsedSpaceLabel.Text = String.Format("{0:0.00} MB ({1} Bytes)", (double)UsedSpace / 1048576, UsedSpace);
        else if (UsedSpace > 1024)
            UsedSpaceLabel.Text = String.Format("{0:0.00} KB({1} Bytes)", (double)UsedSpace / 1024, UsedSpace);
        else
            UsedSpaceLabel.Text = UsedSpace + " Bytes";

    }
    protected void UploadButton_Click(object sender, EventArgs e)
    {
        if (FileUploadControl.HasFile)
        {
            string FileName = FileUploadControl.PostedFile.FileName;
            Int64 FileSize = FileUploadControl.PostedFile.ContentLength;

            string FileExtension = FileName.Substring(FileName.LastIndexOf('.'));

            if (String.Equals(FileExtension, ".exe", StringComparison.OrdinalIgnoreCase))
            {
                StatusLabel.Text = "Upload status: Sorry, '.exe' file uploading is not allowed";
            }
            else if (String.Equals(FileExtension, ".aspx", StringComparison.OrdinalIgnoreCase) || String.Equals(FileExtension, ".asp", StringComparison.OrdinalIgnoreCase))
            {
                StatusLabel.Text = "Upload status: Sorry, '.aspx' or '.asp' file uploading is not allowed";
            }
            else if (FileSize > Capacity - UsedSpace)
            {
                StatusLabel.Text = "Upload status: Sorry, file size exceeds your storage limit";
            }
            else
            {
                string Path = Server.MapPath("~") + "USERSFILES\\" + UserID;
                DirectoryInfo Directory = new DirectoryInfo(Path);
                if (!Directory.Exists)
                {
                    bool Created = CreateUserDirectory();
                    if (!Created)
                    {
                        StatusLabel.Text = "CRITICAL ERROR: User folder could not be created!";
                        return;
                    }
                }
                int StatusUpdateDB = AddFileToDatabase(UserID, FileName, FileSize);
                Path += "\\";

                if (StatusUpdateDB == 0)
                {
                    FileUploadControl.SaveAs(Path + FileName);
                    StatusLabel.Text = "File uploaded successfully";
                    UpdateUsedspace(FileSize);
                }

                else if (StatusUpdateDB == 1)
                    StatusLabel.Text = "Updoad Failed!<br />Reason: You have another file with the same name!";

                else if (StatusUpdateDB == 2)
                    StatusLabel.Text = "Updoad Failed!<br />Reason: Table \"UserInfo\" could not be updated";

                else if (StatusUpdateDB == 3)
                    StatusLabel.Text = "Updoad Failed!<br />Reason: Table \"Files\" could not be updated";
            }
            StatusLabel.Visible = true;
        }
    }
    protected void Logout_Click(object sender, EventArgs e)
    {
        if (Request.Cookies["UserInfo"] != null)
        {
            HttpCookie newCookie = new HttpCookie("UserInfo");
            newCookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(newCookie);
        }
        Session.Abandon();
        Response.Redirect("Login.aspx");
    }
    protected int AddFileToDatabase(string ID, string FileName, Int64 FileSize)
    {
        string CommandString;

        if (FileName.Contains("'"))
            FileName = FileName.Replace("'", "''");

        using (SqlConnection Connection = new SqlConnection(ConnectionString))
        {
            Connection.Open();

            CommandString = "SELECT filename FROM Files WHERE userid='" + UserID + "' and filename='" + FileName + "'";
            SqlCommand CheckCommand = new SqlCommand(CommandString, Connection);
            SqlDataReader Reader = CheckCommand.ExecuteReader();

            // if file exists with the same name as parameter FileName, return 1
            if (Reader.Read())
            {
                if (Reader["filename"].ToString().Equals(FileName))
                {
                    return 1;
                }
            }
        }
        using (SqlConnection Connection = new SqlConnection(ConnectionString))
        {
            Connection.Open();
            Int64 NewUsedSpace = UsedSpace + FileSize;
            CommandString = "UPDATE UserInfo SET usedspace='" + NewUsedSpace + "' WHERE userid='" + UserID + "'";
            SqlCommand Command = new SqlCommand(CommandString, Connection);

            try
            {
                if (Command.ExecuteNonQuery() == 2)
                {
                    return 2;
                }
            }
            catch
            {
                // if update of UserInfo table fails, return 2
                return 2;
            }
        }
        using (SqlConnection Connection = new SqlConnection(ConnectionString))
        {
            Connection.Open();
            CommandString = "INSERT INTO Files (userid, filename, filepath, filesize) values('" + UserID + "','" + FileName + "','root'," + FileSize + ")";
            SqlCommand Command = new SqlCommand(CommandString, Connection);
            try
            {
                if (Command.ExecuteNonQuery() == 0)
                {
                    return 3;
                }
            }
            catch
            {
                // if update of Files table fails, return 3
                return 3;
            }
        }
        // if succeeded, return 0
        return 0;
    }
    private bool CreateUserDirectory()
    {
        string Path = Server.MapPath("~") + "USERSFILES\\";
        DirectoryInfo Directory = new DirectoryInfo(Path);
        try
        {
            Directory.CreateSubdirectory(UserID);
        }
        catch
        {
            return false;
        }
        return true;
    }
    protected void Tab1_Click(object sender, EventArgs e)
    {
        SetSummary();

        Tab1.CssClass = "Clicked";
        Tab2.CssClass = "Initial";
        Tab3.CssClass = "Initial";
        Tab4.CssClass = "Initial";

        SummaryPanel.Visible = true;
        MyFilesPanel.Visible = false;
        UploadPanel.Visible = false;
        TrashPanel.Visible = false;
    }
    protected void Tab2_Click(object sender, EventArgs e)
    {
        Tab1.CssClass = "Initial";
        Tab2.CssClass = "Clicked";
        Tab3.CssClass = "Initial";
        Tab4.CssClass = "Initial";
        SummaryPanel.Visible = false;
        MyFilesPanel.Visible = true;
        UploadPanel.Visible = false;
        TrashPanel.Visible = false;
    }
    protected void Tab3_Click(object sender, EventArgs e)
    {
        Tab1.CssClass = "Initial";
        Tab2.CssClass = "Initial";
        Tab3.CssClass = "Clicked";
        Tab4.CssClass = "Initial";

        SummaryPanel.Visible = false;
        MyFilesPanel.Visible = false;
        UploadPanel.Visible = true;
        TrashPanel.Visible = false;

        StatusLabel.Text = "";
    }
    protected void Tab4_Click(object sender, EventArgs e)
    {
        Tab1.CssClass = "Initial";
        Tab2.CssClass = "Initial";
        Tab3.CssClass = "Initial";
        Tab4.CssClass = "Clicked";

        SummaryPanel.Visible = false;
        MyFilesPanel.Visible = false;
        UploadPanel.Visible = false;
        TrashPanel.Visible = true;

        StatusLabel.Text = "";
        TrashLabel.Visible = false;
    }
    protected void TrashGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string FiringCommand = e.CommandName;
        string Id = e.CommandArgument.ToString();
        string Filename;
        Int64 FileSize;
        if (FiringCommand.Equals("DeleteFromTrashCommand"))
        {
            using (SqlConnection Connection = new SqlConnection(ConnectionString))
            {
                Connection.Open();
                string CommandString = "SELECT filename, filesize FROM Files WHERE Id='" + Id + "'";
                SqlCommand Command = new SqlCommand(CommandString, Connection);
                SqlDataReader Reader = Command.ExecuteReader(CommandBehavior.CloseConnection);
                Reader.Read();
                Filename = Reader["filename"].ToString();
                FileSize = Int64.Parse(Reader["filesize"].ToString());
            }
            using (SqlConnection Connection = new SqlConnection(ConnectionString))
            {
                Connection.Open();
                string CommandString = "DELETE FROM Files WHERE Id='" + Id + "'";
                SqlCommand Command = new SqlCommand(CommandString, Connection);

                int num = Command.ExecuteNonQuery();
                if (num != 0)
                {
                    TrashLabel.Text = String.Format("'{0}' deleted permanently", Filename);
                    string FilePath = Server.MapPath("~") + "USERSFILES\\" + UserID + "\\" + Filename;
                    File.Delete(FilePath);
                    UpdateUsedspace(-FileSize);
                }
                else
                {
                    TrashLabel.Text = String.Format("'{0}' deletion failed", Filename);
                }
                TrashLabel.Visible = true;
            }
        }
        TrashGridView.UpdateRow(0, true);
    }
    protected void MyFilesGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string FiringCommand = e.CommandName;
        if (FiringCommand.Equals("DownloadCommand"))
        {
            using (SqlConnection Connection = new SqlConnection(ConnectionString))
            {
                Connection.Open();
                string CommandString = "SELECT filename, filesize FROM Files WHERE Id='" + e.CommandArgument.ToString() + "'";
                SqlCommand Command = new SqlCommand(CommandString, Connection);

                SqlDataReader Reader = Command.ExecuteReader(CommandBehavior.CloseConnection);
                Reader.Read();
                string path = Server.MapPath("~");
                path += (String.Format("\\USERSFILES\\{0}\\{1}", UserID, @Reader["filename"]));
                FileInfo FileInfo = new FileInfo(path);
                long FileSize = FileInfo.Length;

                Response.ClearContent();
                Response.AddHeader("Content-Disposition", string.Format("attachment; filename = {0}", System.IO.Path.GetFileName(path)));
                Response.AddHeader("Content-Length", FileSize.ToString("F0"));
                Response.TransmitFile(path);
                Response.End();
            }
        }
    }
    protected void MyFilesGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[0].Text = (e.Row.DataItemIndex+1).ToString();
            string FileSizeString = e.Row.Cells[2].Text;
            Int64 FileSize = Int64.Parse(FileSizeString);

            if (FileSize > 1048576)
                FileSizeString = String.Format("{0:0.00} MB", (double)FileSize / 1048576);
            else if (FileSize > 1024)
                FileSizeString = String.Format("{0:0.00} KB", (double)FileSize / 1024);
            else
                FileSizeString = String.Format("{0} B", FileSize);

            e.Row.Cells[2].Text = FileSizeString;
        }
    }
}