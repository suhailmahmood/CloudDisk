<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="UserHome.aspx.cs" Inherits="UserHome" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="Server">
    <title>Register</title>
    <link href="Styles/StyleSheet.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">

    <div>
        <ul id="menu">
            <asp:HyperLink ID="HomeLink" runat="server" Text="Home" NavigateUrl="~/Default.aspx" CssClass="LinkButton"></asp:HyperLink>
            <asp:LinkButton ID="LogoutButton" runat="server" OnClick="Logout_Click" CssClass="LinkButton" Text="Logout"></asp:LinkButton>
        </ul>
    </div>

    <div class="content-wrapper">

        <div id="salutation">
            <asp:Label ID="NameLabel" runat="server" Text=""></asp:Label>
        </div>

        <div class="WidePanel">
            <div id="Tabs">
                <asp:LinkButton Text="Summary" ID="Tab1" CssClass="Initial" runat="server" OnClick="Tab1_Click"></asp:LinkButton>
                <asp:LinkButton Text="My Files" ID="Tab2" CssClass="Initial" runat="server" OnClick="Tab2_Click"></asp:LinkButton>
                <asp:LinkButton Text="Upload" ID="Tab3" CssClass="Initial" runat="server" OnClick="Tab3_Click"></asp:LinkButton>
                <asp:LinkButton Text="Trash" ID="Tab4" CssClass="Initial" runat="server" OnClick="Tab4_Click"></asp:LinkButton>
            </div>

            <div id="TabContent">
                <asp:Panel ID="SummaryPanel" runat="server" CssClass="FullPanel">
                    <table style="margin-top: 40px; border-spacing: 10px 12px;" >
                        <tr>
                            <td>User Type:
                            </td>
                            <td>
                                <asp:Label ID="UserTypeLabel" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr>
                            <td>Total Space:
                            </td>
                            <td>
                                <asp:Label ID="TotalSpaceLabel" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>Used Space:
                            </td>
                            <td>
                                <asp:Label ID="UsedSpaceLabel" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>Total Files:
                            </td>
                            <td>
                                <asp:Label ID="FilesCountLabel" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr>
                            <td>Files in Trash:&nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:Label ID="TrashFilesCountLabel" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <%-- 2nd  Tab  contents  from  below --%>

                <asp:Panel ID="MyFilesPanel" runat="server" CssClass="FullPanel">

                    <asp:GridView ID="MyFilesGridView" runat="server" AutoGenerateColumns="False"
                        OnRowCommand="MyFilesGridView_RowCommand"
                        OnRowDataBound="MyFilesGridView_RowDataBound"
                        DataKeyNames="Id" DataSourceID="SqlDataSource1" EmptyDataText="You don't have any files yet"
                        AllowPaging="True" AllowSorting="True" CellPadding="4" GridLines="None" Width="700px" ForeColor="#333333" ShowHeaderWhenEmpty="True">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="No.">
                                <ItemStyle Width="50px" Font-Size="Small" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="filename" HeaderText="File Name" SortExpression="filename">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle Font-Names="Verdana" Font-Size="Small" HorizontalAlign="Left" Width="300px" Font-Underline="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="filesize" HeaderText="File Size" ReadOnly="True" SortExpression="filesize">
                                <ItemStyle Font-Names="Verdana" Font-Size="Small" HorizontalAlign="Center" Width="120px" />
                            </asp:BoundField>
                            <asp:TemplateField>
                                <ItemStyle Font-Names="Verdana" Font-Size="X-Small" ForeColor="#3366FF" HorizontalAlign="Center" Width="60px" />
                                <ItemTemplate>
                                    <asp:LinkButton ID="DownloadButton" runat="server" CommandArgument='<%# Eval("Id") %>' CommandName="DownloadCommand" Text="Download"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:CommandField ShowDeleteButton="True">
                                <ItemStyle Font-Names="Verdana" Font-Size="X-Small" ForeColor="#3366FF" HorizontalAlign="Center" Width="60px" />
                            </asp:CommandField>
                        </Columns>
                        <EditRowStyle BackColor="#2461BF" />
                        <FooterStyle BackColor="#507CD1" ForeColor="White" Font-Bold="True" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#EFF3FB" Height="30px" />
                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        <SortedAscendingCellStyle BackColor="#F5F7FB" />
                        <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                        <SortedDescendingCellStyle BackColor="#E9EBEF" />
                        <SortedDescendingHeaderStyle BackColor="#4870BE" />
                    </asp:GridView>

                    <%--DeleteCommand="DELETE FROM [Files] WHERE [Id] = @Id"--%>

                    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                        ConnectionString="<%$ ConnectionStrings:Connection %>"
                        ProviderName="<%$ ConnectionStrings:Connection.ProviderName %>"
                        DeleteCommand="UPDATE [Files] SET [filepath] = 'trash' WHERE [Id] = @Id"
                        InsertCommand="INSERT INTO [Files] ([userid], [filename], [filepath], [filesize]) VALUES (@userid, @filename, @filepath, @filesize)"
                        SelectCommand="SELECT [ID], [filename], [filesize] FROM [Files] WHERE [userid] = @userid and [filepath] = 'root'"
                        UpdateCommand="UPDATE [Files] SET [filename] = @filename WHERE [Id] = @Id">
                        <SelectParameters>
                            <asp:SessionParameter Name="userid" SessionField="userid" Type="String" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="userid" Type="String" />
                            <asp:Parameter Name="filename" Type="String" />
                            <asp:Parameter Name="filepath" Type="String" />
                            <asp:Parameter Name="filesize" Type="Int64" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="userid" Type="String" />
                            <asp:Parameter Name="filename" Type="String" />
                            <asp:Parameter Name="filepath" Type="String" />
                            <asp:Parameter Name="filesize" Type="Int64" />
                            <asp:Parameter Name="Id" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>

                    <asp:Label ID="test" Text="" runat="server"></asp:Label>

                </asp:Panel>

                <%-- 3rd  Tab  contents  from  below  --%>

                <asp:Panel ID="UploadPanel" runat="server" CssClass="FullPanel">
                    <br />
                    <p class="small-caps">Upload a file from your local hard drive...</p>
                    <br />
                    <asp:FileUpload ID="FileUploadControl" runat="server" Width="400px" />
                    <br />
                    <br />
                    <asp:Button ID="UploadButton" runat="server" Text="Upload" OnClick="UploadButton_Click" CssClass="Button" />
                    <br /><br /><br />
                    <%--<p class="small-caps">Or paste the link of a file on the internet to download to your CloudDisk drive</p>
                    <br />
                    Url: <asp:TextBox ID="UrlTB" runat="server" Width="370"></asp:TextBox>
                    <asp:Button ID="UrlDownloadButton" runat="server" Text="Download" Width="80px" OnClick="UrlDownloadButton_Click" />
                    <br /><br />--%>
                    <asp:Label ID="StatusLabel" runat="server" Text=""></asp:Label>
                </asp:Panel>

                <%-- 4th  Tab  contents  from  below  --%>

                <asp:Panel ID="TrashPanel" runat="server" CssClass="FullPanel">

                    <asp:GridView ID="TrashGridView" runat="server" AutoGenerateColumns="False"
                        OnRowCommand="TrashGridView_RowCommand"
                        OnRowDataBound="MyFilesGridView_RowDataBound"
                        DataKeyNames="Id" DataSourceID="SqlDataSource2" EmptyDataText="Your Trash is empty"
                        AllowPaging="True" AllowSorting="True" CellPadding="4" ForeColor="#333333" GridLines="None" Width="700px" ShowHeaderWhenEmpty="True">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="No.">
                                <ItemStyle Width="50px" Font-Size="Small" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="filename" HeaderText="File Name" SortExpression="filename">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle Font-Names="Verdana" Font-Size="Small" Width="300px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="filesize" HeaderText="File Size" SortExpression="filesize">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle Font-Names="Verdana" Font-Size="Small" HorizontalAlign="Center" Width="120px" />
                            </asp:BoundField>
                            <asp:CommandField CausesValidation="true" DeleteText="Restore" ShowDeleteButton="True">
                                <ItemStyle Font-Names="Verdana" Font-Size="X-Small" ForeColor="#3366FF" HorizontalAlign="Center" Width="60px" />
                            </asp:CommandField>
                            <asp:TemplateField>
                                <ItemStyle Font-Names="Verdana" Font-Size="X-Small" ForeColor="#3366FF" HorizontalAlign="Center" Width="60px" />
                                <ItemTemplate>
                                    <asp:LinkButton ID="DeleteFromTrashButton" runat="server" CommandArgument='<%# Eval("Id") %>' CommandName="DeleteFromTrashCommand" Text="Delete"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EditRowStyle BackColor="#2461BF" />
                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#EFF3FB" Height="30px" />
                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        <SortedAscendingCellStyle BackColor="#F5F7FB" />
                        <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                        <SortedDescendingCellStyle BackColor="#E9EBEF" />
                        <SortedDescendingHeaderStyle BackColor="#4870BE" />
                    </asp:GridView>

                    <%-- INSERT INTO [Files] ([userid], [filename], [filepath], [filesize]) VALUES (@userid, @filename, @filepath, @filesize) --%>

                    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                        ConnectionString="<%$ ConnectionStrings:Connection %>"
                        ProviderName="<%$ ConnectionStrings:Connection.ProviderName %>"
                        DeleteCommand="UPDATE [Files] SET [filepath] = 'root' WHERE [Id] = @Id"
                        SelectCommand="SELECT [Id], [userid], [filename], [filepath], [filesize] FROM [Files] WHERE [userid] = @userid and [filepath] = 'trash'"
                        UpdateCommand="UPDATE Files SET filename='' WHERE Id=-1">

                        <SelectParameters>
                            <asp:SessionParameter Name="userid" SessionField="userid" Type="String" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="userid" Type="String" />
                            <asp:Parameter Name="filename" Type="String" />
                            <asp:Parameter Name="filepath" Type="String" />
                            <asp:Parameter Name="filesize" Type="Int64" />
                        </InsertParameters>

                    </asp:SqlDataSource>

                    <asp:Label ID="TrashLabel" runat="server" Text="" Visible="false"></asp:Label>

                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
