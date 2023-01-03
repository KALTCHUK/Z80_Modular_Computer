Imports EasyModbus


Public Class Form1
    Private MBclient As New ModbusClient With {
            .SerialPort = "COM11",
            .Baudrate = 9600,
            .UnitIdentifier = 7
        }

    Private Sub ButtonConnect_Click(sender As Object, e As EventArgs) Handles ButtonConnect.Click
        Try
            MBclient.SerialPort = TextBoxPort.Text
            MBclient.Baudrate = TextBoxBaudRate.Text
            MBclient.Connect()

            If MBclient.Connected Then
                LabelStatus.Text = "Connected."
                GroupBoxDevices.Enabled = True
            End If
        Catch ex As Exception
            LabelStatus.Text = "Error!"
        End Try
    End Sub

    Private Sub ButtonReadCoils_Click(sender As Object, e As EventArgs) Handles ButtonReadCoils.Click
        Dim coilStatus(7) As Boolean

        MBclient.UnitIdentifier = TextBoxSlaveIDDO08.Text
        coilStatus = MBclient.ReadCoils(0, 8)
        LabelCoil1.Text = coilStatus(0)
        LabelCoil2.Text = coilStatus(1)
        LabelCoil3.Text = coilStatus(2)
        LabelCoil4.Text = coilStatus(3)
        LabelCoil5.Text = coilStatus(4)
        LabelCoil6.Text = coilStatus(5)
        LabelCoil7.Text = coilStatus(6)
        LabelCoil8.Text = coilStatus(7)
    End Sub

    Private Sub ButtonWriteCoils_Click(sender As Object, e As EventArgs) Handles ButtonWriteCoils.Click
        Dim coilStatus(7) As Boolean

        coilStatus(0) = CheckBoxCoil1.Checked
        coilStatus(1) = CheckBoxCoil2.Checked
        coilStatus(2) = CheckBoxCoil3.Checked
        coilStatus(3) = CheckBoxCoil4.Checked
        coilStatus(4) = CheckBoxCoil5.Checked
        coilStatus(5) = CheckBoxCoil6.Checked
        coilStatus(6) = CheckBoxCoil7.Checked
        coilStatus(7) = CheckBoxCoil8.Checked

        MBclient.UnitIdentifier = TextBoxSlaveIDDO08.Text
        MBclient.WriteMultipleCoils(0, coilStatus)

        LabelCoil1.Text = ""
        LabelCoil2.Text = ""
        LabelCoil3.Text = ""
        LabelCoil4.Text = ""
        LabelCoil5.Text = ""
        LabelCoil6.Text = ""
        LabelCoil7.Text = ""
        LabelCoil8.Text = ""

    End Sub

    Private Sub ButtonReadRegister40001_Click(sender As Object, e As EventArgs) Handles ButtonReadDO08Register40001.Click
        Dim regVal As Integer()

        MBclient.UnitIdentifier = TextBoxSlaveIDDO08.Text
        regVal = MBclient.ReadHoldingRegisters(0, 1)
        If regVal(0) < 0 Then
            LabelDO08Register40001.Text = regVal(0) + 65536
        Else
            LabelDO08Register40001.Text = regVal(0)
        End If
    End Sub

    Private Sub ButtonReadRegister40002_Click(sender As Object, e As EventArgs) Handles ButtonReadDO08Register40002.Click
        Dim regVal As Integer()

        MBclient.UnitIdentifier = TextBoxSlaveIDDO08.Text
        regVal = MBclient.ReadHoldingRegisters(1, 1)
        If regVal(0) < 0 Then
            LabelDO08Register40002.Text = regVal(0) + 65536
        Else
            LabelDO08Register40002.Text = regVal(0)
        End If
    End Sub

    Private Sub ButtonWriteRegister40001_Click(sender As Object, e As EventArgs) Handles ButtonWriteDO08Register40001.Click
        MBclient.UnitIdentifier = TextBoxSlaveIDDO08.Text
        MBclient.WriteSingleRegister(0, TextBoxDO08Register40001.Text)
        LabelDO08Register40001.Text = ""
    End Sub

    Private Sub ButtonWriteRegister40002_Click(sender As Object, e As EventArgs) Handles ButtonWriteDO08Register40002.Click
        MBclient.UnitIdentifier = TextBoxSlaveIDDO08.Text
        MBclient.WriteSingleRegister(1, TextBoxDO08Register40002.Text)
        LabelDO08Register40002.Text = ""
    End Sub

    Private Sub ButtonSetAll_Click(sender As Object, e As EventArgs) Handles ButtonSetAll.Click
        CheckBoxCoil1.Checked = True
        CheckBoxCoil2.Checked = True
        CheckBoxCoil3.Checked = True
        CheckBoxCoil4.Checked = True
        CheckBoxCoil5.Checked = True
        CheckBoxCoil6.Checked = True
        CheckBoxCoil7.Checked = True
        CheckBoxCoil8.Checked = True
    End Sub

    Private Sub ButtonResetAll_Click(sender As Object, e As EventArgs) Handles ButtonResetAll.Click
        CheckBoxCoil1.Checked = False
        CheckBoxCoil2.Checked = False
        CheckBoxCoil3.Checked = False
        CheckBoxCoil4.Checked = False
        CheckBoxCoil5.Checked = False
        CheckBoxCoil6.Checked = False
        CheckBoxCoil7.Checked = False
        CheckBoxCoil8.Checked = False
    End Sub

    Private Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        Dim contactStatus(15) As Boolean

        MBclient.UnitIdentifier = TextBoxSlaveIDDI16.Text
        contactStatus = MBclient.ReadDiscreteInputs(0, 16)

        LabelContact10001.Text = contactStatus(0)
        LabelContact10002.Text = contactStatus(0)
        LabelContact10003.Text = contactStatus(0)
        LabelContact10004.Text = contactStatus(0)
        LabelContact10005.Text = contactStatus(0)
        LabelContact10006.Text = contactStatus(0)
        LabelContact10007.Text = contactStatus(0)
        LabelContact10008.Text = contactStatus(0)
        LabelContact10009.Text = contactStatus(0)
        LabelContact10010.Text = contactStatus(0)
        LabelContact10011.Text = contactStatus(0)
        LabelContact10012.Text = contactStatus(0)
        LabelContact10013.Text = contactStatus(0)
        LabelContact10014.Text = contactStatus(0)
        LabelContact10015.Text = contactStatus(0)
        LabelContact10016.Text = contactStatus(0)
    End Sub

    Private Sub CheckBoxEnableRefresh_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBoxEnableRefresh.CheckedChanged
        If CheckBoxEnableRefresh.Checked = True Then
            Timer1.Interval = TextBoxRefresh.Text
            Timer1.Start()
        Else
            Timer1.Stop()
        End If
    End Sub

    Private Sub CheckBoxEnableDO08_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBoxEnableDO08.CheckedChanged
        If CheckBoxEnableDO08.Checked Then
            GroupBoxRegistersDO08.Enabled = True
            GroupBoxCoils.Enabled = True
            TextBoxSlaveIDDO08.Enabled = True
        Else
            GroupBoxRegistersDO08.Enabled = False
            GroupBoxCoils.Enabled = False
            TextBoxSlaveIDDO08.Enabled = False
        End If
    End Sub

    Private Sub CheckBoxEnableDI16_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBoxEnableDI16.CheckedChanged
        If CheckBoxEnableDI16.Checked Then
            GroupBoxRegistersDI16.Enabled = True
            GroupBoxContacts.Enabled = True
            TextBoxSlaveIDDI16.Enabled = True
        Else
            GroupBoxRegistersDI16.Enabled = False
            GroupBoxContacts.Enabled = False
            TextBoxSlaveIDDI16.Enabled = False
        End If
    End Sub

    Private Sub ButtonReadDI16Register40001_Click(sender As Object, e As EventArgs) Handles ButtonReadDI16Register40001.Click
        Dim regVal As Integer()

        MBclient.UnitIdentifier = TextBoxSlaveIDDI16.Text
        regVal = MBclient.ReadHoldingRegisters(0, 1)
        If regVal(0) < 0 Then
            LabelDI16Register40001.Text = regVal(0) + 65536
        Else
            LabelDI16Register40001.Text = regVal(0)
        End If
    End Sub

    Private Sub ButtonReadDI16Register40002_Click(sender As Object, e As EventArgs) Handles ButtonReadDI16Register40002.Click
        Dim regVal As Integer()

        MBclient.UnitIdentifier = TextBoxSlaveIDDI16.Text
        regVal = MBclient.ReadHoldingRegisters(1, 1)
        If regVal(0) < 0 Then
            LabelDI16Register40002.Text = regVal(0) + 65536
        Else
            LabelDI16Register40002.Text = regVal(0)
        End If
    End Sub

    Private Sub ButtonWriteDI16Register40001_Click(sender As Object, e As EventArgs) Handles ButtonWriteDI16Register40001.Click
        MBclient.UnitIdentifier = TextBoxSlaveIDDI16.Text
        MBclient.WriteSingleRegister(0, TextBoxDI16Register40001.Text)
        LabelDI16Register40001.Text = ""
    End Sub

    Private Sub ButtonWriteDI16Register40002_Click(sender As Object, e As EventArgs) Handles ButtonWriteDI16Register40002.Click
        MBclient.UnitIdentifier = TextBoxSlaveIDDI16.Text
        MBclient.WriteSingleRegister(1, TextBoxDI16Register40002.Text)
        LabelDI16Register40002.Text = ""
    End Sub
End Class
