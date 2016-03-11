<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="Server">
    <title>Register</title>
    <link href="Styles/StyleSheet.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div>
        <ul id="menu">
            <asp:HyperLink ID="HomeLink" runat="server" Text="Home" NavigateUrl="~/Default.aspx" CssClass="LinkButton"></asp:HyperLink>
            <asp:HyperLink ID="LoginLink" runat="server" Text="Login" NavigateUrl="~/Login.aspx" CssClass="LinkButton"></asp:HyperLink>
        </ul>
    </div>
    <div class="content-wrapper">
        <asp:Panel ID="TablePanel" runat="server" CssClass="Panel">

            <h3>Register</h3>

            <asp:Table ID="Table" runat="server">

                <asp:TableHeaderRow>
                    <asp:TableCell ColumnSpan="3">
                        Please use the form below to register to our Website
                    </asp:TableCell>
                </asp:TableHeaderRow>

                <asp:TableRow>
                    <asp:TableCell></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell>Full Name:</asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="NameTB" runat="server"></asp:TextBox>
                    </asp:TableCell>
                    <asp:TableCell><asp:RequiredFieldValidator CssClass="ValidationError"
                        ControlToValidate="NameTB" runat="server"
                        ErrorMessage="Enter your full name" SetFocusOnError="true"></asp:RequiredFieldValidator></asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>User ID:</asp:TableCell>
                    <asp:TableCell>
                        <asp:UpdatePanel ID="RegisterFormUpdatePanel" runat="server">
                            <ContentTemplate>
                                <asp:TextBox ID="UserIDTB" runat="server" AutoPostBack="true" OnTextChanged="UserIDTB_TextChanged"></asp:TextBox>
                                <asp:Label ID="UserIDCheck" runat="server" Text="UserID not available" Visible="false"></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:RequiredFieldValidator CssClass="ValidationError"
                            ControlToValidate="UserIDTB" runat="server"
                            ErrorMessage="Enter a unique User ID" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </asp:TableCell>

                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>Password:</asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="PasswordTB" TextMode="Password" runat="server"></asp:TextBox>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:RequiredFieldValidator CssClass="ValidationError"
                            ControlToValidate="PasswordTB" runat="server"
                            ErrorMessage="Password field can not be empty" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell>Re-enter password:</asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="ConfirmPasswordTB" TextMode="Password" runat="server"></asp:TextBox>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:CompareValidator CssClass="ValidationError"
                            ControlToCompare="ConfirmPasswordTB" ControlToValidate="PasswordTB" runat="server"
                            ErrorMessage="Passwords don't match"></asp:CompareValidator>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>Email address:</asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="EmailTB" TextMode="Email" runat="server"></asp:TextBox>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:RequiredFieldValidator CssClass="ValidationError" ControlToValidate="EmailTB" runat="server"
                            ErrorMessage="Enter a valid email address" />
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell></asp:TableCell><asp:TableCell>
                        <asp:Button ID="RegisterButton" runat="server" Text="Register" OnClick="RegisterButton_Click" CssClass="Button float-left" />
                    </asp:TableCell>
                </asp:TableRow>

            </asp:Table>
        </asp:Panel>
        <asp:Panel ID="MessagePanel" runat="server" Visible="false" CssClass="Panel">
            <asp:Label ID="Message" runat="server" Text=""></asp:Label>
            <asp:Button ID="Next" runat="server" Text="" OnClick="Next_Click" CssClass="Button" />
        </asp:Panel>
    </div>
</asp:Content>

