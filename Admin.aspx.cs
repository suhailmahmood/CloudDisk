using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataBind();
        if((string)Session["userid"] != "Admin")
        {
            Response.Redirect("Default.aspx");
        }
        else if(!IsPostBack)
        {
            ConfirmationPanel.Visible = true;
        }
    }

    protected void LoginButton_Click(object sender, EventArgs e)
    {
        using (SqlConnection Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Connection"].ToString()))
        {
            Connection.Open();
            SqlCommand Command = new SqlCommand("SELECT password from UserInfo WHERE userid='Admin'", Connection);
            SqlDataReader Reader = Command.ExecuteReader(CommandBehavior.CloseConnection);
            Reader.Read();

            if (PasswordTB.Text.Equals(Reader["password"].ToString()))
            {
                ConfirmationPanel.Visible = false;
                UserInfoPanel.Visible = true;
                LogoutButton.Visible = true;
                FilesPanel.Visible = false;
            }
            else
            {
                LogoutButton.Visible = false;
                Message.Text = "Wrong password!";
            }
        }
    }
    protected void LogoutButton_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("Default.aspx");
    }
}