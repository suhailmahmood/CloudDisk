using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if ((string)Session["current"] == "running")
        {
            using (SqlConnection Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Connection"].ToString()))
            {
                Connection.Open();
                SqlCommand Command = new SqlCommand("SELECT name FROM UserInfo WHERE userid='" + Session["userid"] + "'", Connection);
                try
                {
                    SqlDataReader Reader = Command.ExecuteReader(CommandBehavior.CloseConnection);
                    Reader.Read();

                    UserHomeLink.Text = Reader["name"].ToString();
                    RegisterLink.Visible = false;
                    LoginLink.Visible = false;
                    UserHomeLink.Visible = true;
                    LogoutButton.Visible = true;
                }
                catch (Exception Exception)
                {
                    Message.Text = Exception.Message;
                    Message.Visible = true;
                }
            }
        }
    }
    protected void LogoutButton_Click(object sender, EventArgs e)
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
}