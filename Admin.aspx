<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Admin.aspx.cs" Inherits="Admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin - CloudDisk.com</title>
    <link href="Styles/StyleSheet2.css" rel="stylesheet" />
</head>

<body>
    <form id="form1" runat="server">
        <header>
            <div class="title">
                <h1>CloudDisk.com</h1>
                <h3>Administrator</h3>
                <p>
                    <asp:Button ID="LogoutButton" runat="server" Text="Logout Admin" OnClick="LogoutButton_Click" Visible="false"/>
                </p>
            </div>
        </header>

        <asp:Panel ID="ConfirmationPanel" runat="server">
            Please enter the Administrator password again:<br />
            <asp:TextBox ID="PasswordTB" runat="server" TextMode="Password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="Validator" ErrorMessage="Empty password field!" ControlToValidate="PasswordTB" runat="server" />
            <br />
            <asp:Button ID="LoginButton" runat="server" Text="Login" OnClick="LoginButton_Click" />
            <br />
            <asp:Label ID="Message" runat="server" Text=""></asp:Label>
        </asp:Panel>

        <asp:Panel ID="UserInfoPanel" runat="server" Visible="false">
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="userid" DataSourceID="SqlDataSource1" EmptyDataText="There are no data records to display.">
                <Columns>
                    <asp:BoundField DataField="userid" HeaderText="userid" ReadOnly="True" SortExpression="userid" />
                    <asp:BoundField DataField="password" HeaderText="password" SortExpression="password" />
                    <asp:BoundField DataField="name" HeaderText="name" SortExpression="name" />
                    <asp:BoundField DataField="email" HeaderText="email" SortExpression="email" />
                    <asp:BoundField DataField="capacity" HeaderText="capacity" SortExpression="capacity" />
                    <asp:BoundField DataField="usedspace" HeaderText="usedspace" SortExpression="usedspace" />
                    <asp:BoundField DataField="usertype" HeaderText="usertype" SortExpression="usertype" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Connection %>" DeleteCommand="DELETE FROM [UserInfo] WHERE [userid] = @userid" InsertCommand="INSERT INTO [UserInfo] ([userid], [password], [name], [email], [capacity], [usedspace], [usertype]) VALUES (@userid, @password, @name, @email, @capacity, @usedspace, @usertype)" ProviderName="<%$ ConnectionStrings:Connection.ProviderName %>" SelectCommand="SELECT [userid], [password], [name], [email], [capacity], [usedspace], [usertype] FROM [UserInfo]" UpdateCommand="UPDATE [UserInfo] SET [password] = @password, [name] = @name, [email] = @email, [capacity] = @capacity, [usedspace] = @usedspace, [usertype] = @usertype WHERE [userid] = @userid">
                <DeleteParameters>
                    <asp:Parameter Name="userid" Type="String" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="userid" Type="String" />
                    <asp:Parameter Name="password" Type="String" />
                    <asp:Parameter Name="name" Type="String" />
                    <asp:Parameter Name="email" Type="String" />
                    <asp:Parameter Name="capacity" Type="Int64" />
                    <asp:Parameter Name="usedspace" Type="Int64" />
                    <asp:Parameter Name="usertype" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="password" Type="String" />
                    <asp:Parameter Name="name" Type="String" />
                    <asp:Parameter Name="email" Type="String" />
                    <asp:Parameter Name="capacity" Type="Int64" />
                    <asp:Parameter Name="usedspace" Type="Int64" />
                    <asp:Parameter Name="usertype" Type="String" />
                    <asp:Parameter Name="userid" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>

        </asp:Panel>

        <asp:Panel ID="FilesPanel" runat="server" Visible="false">
        </asp:Panel>

    </form>
</body>
</html>
