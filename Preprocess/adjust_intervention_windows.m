% TODO: Sync to start of pumpthombosis and make equal time windows



part = data(data.note_row==30,:);
cwt(part.acc_length,part.Properties.SampleRate);
figure
part = data(data.note_row==31,:);
cwt(part.acc_length,part.Properties.SampleRate);

