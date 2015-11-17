AES algorithm for student education (AES_Student).

In this project you can examine cryptographic algorithm AES. Project is written using Delphi 7 personal.

Advanced Encryption Standard (AES) perceived as a whole makes a huge and complex transformation. However, it comprises of certain number minor and much simpler transformations. The idea of this code is to help students in understanding its parts and essentials. Once we realize its comprising parts the algorithm itself is very simple.

AES_Student gives you a opportunity to examine main AES parts - Galois multiplication in various forms (including polynomials view), SubBytes? transformation (AES S-Box), ShiftRows? and MixColumns? transformations, InvShiftRows? and InvMixColumns? transformations, Cipher and InvCipher? (including block by block and line by line view), Monte Carlo tests and real cipher.

To compile this project, you will have to use TWebBrowser class - unit SHDocVw_TLB or SHDocVw.

If you use Delphi 7 personal, you have to:
1. On the "Component" menu in the main toolbar select "Import ActiveX Control..."
2. In the list box scroll and and select "Microsoft Internet Controls".
The "Class names" should then list "TWebBrower".
3. Click "Install
4. Click "OK" on the "Install" form that appears and "Yes" on the confirm prompt.
In uses clause in all units there is already SHDocVw_TLB listed.
If you use some other Delphi version (and you have Internet suite installed), you have to change uses clause in all units from SHDocVw_TLB to SHDocVw.

You can also look at my crypto2 project at http://code.google.com/p/crypto2

Boris Damjanovic
-------

In this project, you will have to use TWebBrowser class - unit SHDocVw_TLB or SHDocVw.

If you use Delphi 7 personal, you have to:
1. On the "Component" menu in the main toolbar select "Import ActiveX Control..."
2. In the list box scroll and and select "Microsoft Internet Controls".
   The "Class names" should then list "TWebBrower".
3. Click "Install..." (not "Create Unit")
4. Click "OK" on the "Install" form that appears and "Yes" on the confirm prompt.
In uses clause in all units there is already SHDocVw_TLB listed.


If you use some other Delphi version (and you have Internet suite installed), you have to  change uses clause in all units from SHDocVw_TLB to SHDocVw.

