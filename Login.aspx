<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="Server">
    <title>Register</title>
    <link href="Styles/StyleSheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">
    <div>
        <ul id="menu">
            <asp:HyperLink ID="RegisterLink" runat="server" Text="Home" NavigateUrl="~/Default.aspx" CssClass="LinkButton"></asp:HyperLink>
            <asp:HyperLink ID="LoginLink" runat="server" Text="Register" NavigateUrl="~/Register.aspx" CssClass="LinkButton"></asp:HyperLink>
        </ul>
    </div>
    <div class="content-wrapper">
        <asp:Panel ID="TablePanel" runat="server" CssClass="Panel">
            <h3>Login</h3>
            <asp:Table ID="Table" runat="server">
                <asp:TableHeaderRow>
                    <asp:TableCell ColumnSpan="3">
                        Enter your User-ID and password to login
                    </asp:TableCell>
                </asp:TableHeaderRow>
                <asp:TableRow>
                    <asp:TableCell></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell>User-ID:</asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="UserIDTB" runat="server"></asp:TextBox>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:RequiredFieldValidator CssClass="ValidationError"
                            ControlToValidate="UserIDTB" runat="server"
                            ErrorMessage="Enter your User-ID" SetFocusOnError="true">
                        </asp:RequiredFieldValidator>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell>Password:</asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="PasswordTB" runat="server" TextMode="Password"></asp:TextBox>
                    </asp:TableCell>
                    <asp:TableCell><asp:RequiredFieldValidator CssClass="ValidationError"
                        ControlToValidate="PasswordTB" runat="server"
                        ErrorMessage="Password field can not be empty" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell></asp:TableCell>
                    <asp:TableCell>
                        <asp:CheckBox ID="RememberMe" runat="server" Text="Remeber Me" CssClass="Message" /></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell></asp:TableCell>
                    <asp:TableCell>
                        <asp:Button ID="LoginButton" runat="server" Text="Login" OnClick="LoginButton_Click" CssClass="Button"/></asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </asp:Panel>
        <asp:Panel ID="MessagePanel" runat="server" Visible="false" CssClass="Panel Message">
            <asp:Label ID="Message" runat="server" Text=""></asp:Label>
        </asp:Panel>
    </div>
</asp:Content>

