<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="Server">
    <title>Cloud Disk Home</title>
    <link href="Styles/StyleSheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">

    <div>
        <ul id="menu">
            <asp:HyperLink ID="RegisterLink" runat="server" Text="Register" NavigateUrl="~/Register.aspx" Visible="true" CssClass="LinkButton"></asp:HyperLink>
            <asp:HyperLink ID="LoginLink" runat="server" Text="Login" NavigateUrl="~/Login.aspx" Visible="true" CssClass="LinkButton"></asp:HyperLink>
            <asp:HyperLink ID="UserHomeLink" runat="server" Text="" NavigateUrl="~/UserHome.aspx" Visible="false" CssClass="LinkButton"></asp:HyperLink>
            <asp:LinkButton ID="LogoutButton" runat="server" Text="Logout" OnClick="LogoutButton_Click" Visible="false" CssClass="LinkButton"></asp:LinkButton>
            <%--<li><a href="Help.aspx" target="_self">Help</a></li>--%>
        </ul>
    </div>
    <div class="content-wrapper">
        <br />
        <h2 class="indent">Welcome to CloudDisk !</h2>
        <br />
        <p class="indent">
            Its just like your hard disk that never loses your data<br />
            To get started, please <a href="Register.aspx" class="undecorated_link">Register</a>, or <a href="Login.aspx" class="undecorated_link">Login</a>
        </p>
        <asp:Label ID="Message" runat="server" Text="" Visible="false"></asp:Label>
    </div>
</asp:Content>

