using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if ((string)Session["current"] == "running")
        {
            Response.Redirect("UserHome.aspx");
        }
        else if (Request.Cookies["UserInfo"] != null)
        {
            Session["current"] = "running";
            Session["userid"] = Request.Cookies["UserInfo"]["userid"];
            Response.Redirect("UserHome.aspx");
        }
        
        if(IsPostBack)
        {
            MessagePanel.Visible = true;
        }
    }
    protected void LoginButton_Click(object sender, EventArgs e)
    {
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Connection"].ToString()))
        {
            con.Open();
            string commandString = "SELECT * FROM UserInfo where userid='" + UserIDTB.Text + "'";
            SqlCommand command = new SqlCommand(commandString, con);
            SqlDataReader reader = command.ExecuteReader(CommandBehavior.CloseConnection);

            if (!reader.Read())
            {
                Message.Text = "User-ID does not exist!";
                MessagePanel.Visible = true;
            }
            else if((String.Compare(reader["userid"].ToString(), "Admin", false) == 0 && PasswordTB.Text.Equals(reader["password"].ToString())))
            {
                Session["userid"] = "Admin";
                Response.Redirect("Admin.aspx");
            }
            else if (reader["password"].ToString() != PasswordTB.Text)
            {
                Message.Text = "Wrong password";
                MessagePanel.Visible = true;
            }
            else
            {
                Session["current"] = "running";
                Session["userid"] = reader["userid"];
                if (RememberMe.Checked)
                {
                    HttpCookie MyCookie = new HttpCookie("UserInfo");
                    MyCookie["userid"] = reader["userid"].ToString();
                    MyCookie.Expires = DateTime.Now.AddDays(7);
                    Response.Cookies.Add(MyCookie);
                }
                Response.Redirect("UserHome.aspx");
            }
        }
    }
}