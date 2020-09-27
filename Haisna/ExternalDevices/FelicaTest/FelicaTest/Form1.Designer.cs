namespace FelicaTest
{
    partial class Form1
    {
        /// <summary>
        /// 必要なデザイナー変数です。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 使用中のリソースをすべてクリーンアップします。
        /// </summary>
        /// <param name="disposing">マネージ リソースを破棄する場合は true を指定し、その他の場合は false を指定します。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows フォーム デザイナーで生成されたコード

        /// <summary>
        /// デザイナー サポートに必要なメソッドです。このメソッドの内容を
        /// コード エディターで変更しないでください。
        /// </summary>
        private void InitializeComponent()
        {
            this.StartButton = new System.Windows.Forms.Button();
            this.StopButton = new System.Windows.Forms.Button();
            this.CardValueTextBox = new System.Windows.Forms.TextBox();
            this.WriteButton = new System.Windows.Forms.Button();
            this.WriteValueTextBox = new System.Windows.Forms.MaskedTextBox();
            this.CardBytesTextBox = new System.Windows.Forms.TextBox();
            this.ReadButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // StartButton
            // 
            this.StartButton.Location = new System.Drawing.Point(338, 58);
            this.StartButton.Name = "StartButton";
            this.StartButton.Size = new System.Drawing.Size(136, 58);
            this.StartButton.TabIndex = 0;
            this.StartButton.Text = "Start";
            this.StartButton.UseVisualStyleBackColor = true;
            this.StartButton.Click += new System.EventHandler(this.StartButton_Click);
            // 
            // StopButton
            // 
            this.StopButton.Location = new System.Drawing.Point(484, 58);
            this.StopButton.Name = "StopButton";
            this.StopButton.Size = new System.Drawing.Size(134, 58);
            this.StopButton.TabIndex = 1;
            this.StopButton.Text = "Stop";
            this.StopButton.UseVisualStyleBackColor = true;
            this.StopButton.Click += new System.EventHandler(this.StopButton_Click);
            // 
            // CardValueTextBox
            // 
            this.CardValueTextBox.Enabled = false;
            this.CardValueTextBox.Location = new System.Drawing.Point(59, 72);
            this.CardValueTextBox.Name = "CardValueTextBox";
            this.CardValueTextBox.Size = new System.Drawing.Size(232, 31);
            this.CardValueTextBox.TabIndex = 2;
            this.CardValueTextBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // WriteButton
            // 
            this.WriteButton.Location = new System.Drawing.Point(338, 272);
            this.WriteButton.Name = "WriteButton";
            this.WriteButton.Size = new System.Drawing.Size(424, 58);
            this.WriteButton.TabIndex = 3;
            this.WriteButton.Text = "Write";
            this.WriteButton.UseVisualStyleBackColor = true;
            this.WriteButton.Click += new System.EventHandler(this.WriteButton_Click);
            // 
            // WriteValueTextBox
            // 
            this.WriteValueTextBox.Location = new System.Drawing.Point(59, 286);
            this.WriteValueTextBox.Name = "WriteValueTextBox";
            this.WriteValueTextBox.Size = new System.Drawing.Size(232, 31);
            this.WriteValueTextBox.TabIndex = 4;
            this.WriteValueTextBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // CardBytesTextBox
            // 
            this.CardBytesTextBox.Enabled = false;
            this.CardBytesTextBox.Location = new System.Drawing.Point(59, 148);
            this.CardBytesTextBox.Name = "CardBytesTextBox";
            this.CardBytesTextBox.Size = new System.Drawing.Size(703, 31);
            this.CardBytesTextBox.TabIndex = 5;
            this.CardBytesTextBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // ReadButton
            // 
            this.ReadButton.Location = new System.Drawing.Point(628, 58);
            this.ReadButton.Name = "ReadButton";
            this.ReadButton.Size = new System.Drawing.Size(134, 58);
            this.ReadButton.TabIndex = 6;
            this.ReadButton.Text = "Read";
            this.ReadButton.UseVisualStyleBackColor = true;
            this.ReadButton.Click += new System.EventHandler(this.ReadButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(13F, 24F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(826, 405);
            this.Controls.Add(this.ReadButton);
            this.Controls.Add(this.CardBytesTextBox);
            this.Controls.Add(this.WriteValueTextBox);
            this.Controls.Add(this.WriteButton);
            this.Controls.Add(this.CardValueTextBox);
            this.Controls.Add(this.StopButton);
            this.Controls.Add(this.StartButton);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button StartButton;
        private System.Windows.Forms.Button StopButton;
        private System.Windows.Forms.TextBox CardValueTextBox;
        private System.Windows.Forms.Button WriteButton;
        private System.Windows.Forms.MaskedTextBox WriteValueTextBox;
        private System.Windows.Forms.TextBox CardBytesTextBox;
        private System.Windows.Forms.Button ReadButton;
    }
}

