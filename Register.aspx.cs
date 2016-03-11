using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void RegisterButton_Click(object sender, EventArgs e)
    {
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Connection"].ToString()))
        {
            con.Open();
            string commandString = "INSERT INTO UserInfo (userid, password, name, email, usertype) values ('" + UserIDTB.Text + "', '" + PasswordTB.Text + "','" + NameTB.Text + "','" + EmailTB.Text + "', 'Basic')";
            SqlCommand command = new SqlCommand(commandString, con);

            try
            {
                command.ExecuteNonQuery();
                TablePanel.Visible = false;
                Message.Text = "Congratulations!!<br />Registration Completed Successfully<br />Please click Next to continue<br /><br />";
                Next.Text = "Next";
                MessagePanel.Visible = true;
            }
            catch
            {
                TablePanel.Visible = false;
                Message.Text = "User already exists!<br />Please click Back and enter a different UserID<br /><br />";
                Next.Text = "Back";
                MessagePanel.Visible = true;
            }
        }
        CreateUserDirectory();
    }

    private void CreateUserDirectory()
    {
        string Path = Server.MapPath("") + "\\USERSFILES\\";
        DirectoryInfo Directory = new DirectoryInfo(Path);
        try
        {
            Directory.CreateSubdirectory(UserIDTB.Text);
        }
        catch
        {
            Message.Text = "Critical ERROR: User folder could not be created!";
        }
    }
    protected void Next_Click(object sender, EventArgs e)
    {
        if (Next.Text == "Next")
        {
            Session["current"] = "running";
            Session["userid"] = UserIDTB.Text;
            Response.Redirect("UserHome.aspx");
        }
        else
            Response.RedirectPermanent("Register.aspx");
    }
    protected void UserIDTB_TextChanged(object sender, EventArgs e)
    {
        using (SqlConnection Connecion = new SqlConnection(ConfigurationManager.ConnectionStrings["Connection"].ToString()))
        {
            Connecion.Open();
            string CommandString = String.Format("SELECT userid FROM UserInfo WHERE userid='{0}'", UserIDTB.Text);
            SqlCommand Command = new SqlCommand(CommandString, Connecion);
            SqlDataReader Reader = Command.ExecuteReader(CommandBehavior.CloseConnection);

            if(Reader.HasRows)
            {
                UserIDCheck.Text = "UserID not available";
                UserIDCheck.Visible = true;
            }
            else
            {
                UserIDCheck.Text = "";
                UserIDCheck.Visible = false;
            }
        }
    }
}