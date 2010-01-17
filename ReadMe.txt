In this project, you will have to use TWebBrowser class - unit SHDocVw_TLB or SHDocVw.

If you use Delphi 7 personal, you have to:
1. On the "Component" menu in the main toolbar select "Import ActiveX Control..."
2. In the list box scroll and and select "Microsoft Internet Controls".
   The "Class names" should then list "TWebBrower".
3. Click "Install..." (not "Create Unit")
4. Click "OK" on the "Install" form that appears and "Yes" on the confirm prompt.
In uses clause in all units there is already SHDocVw_TLB listed.


If you use some other Delphi version (and you have Internet suite installed), you have to  change uses clause in all units from SHDocVw_TLB to SHDocVw.

