/*
 * 汎用テーブル（汎用分類コードの項目長拡張）
 */
alter table free modify freeclasscd varchar2(12);

/*
 * 新汎用項目定義（入金種別）
 */
insert all
into free (freecd, freeclasscd, freename, freefield1, freefield2) values ('PAYMENTDIV01', 'PAYMENTDIV', '入金種別', '1', '現金')
into free (freecd, freeclasscd, freename, freefield1, freefield2) values ('PAYMENTDIV02', 'PAYMENTDIV', '入金種別', '2', '小切手')
into free (freecd, freeclasscd, freename, freefield1, freefield2) values ('PAYMENTDIV03', 'PAYMENTDIV', '入金種別', '3', '振込み')
into free (freecd, freeclasscd, freename, freefield1, freefield2) values ('PAYMENTDIV04', 'PAYMENTDIV', '入金種別', '4', '福利厚生')
into free (freecd, freeclasscd, freename, freefield1, freefield2) values ('PAYMENTDIV05', 'PAYMENTDIV', '入金種別', '5', 'カード')
into free (freecd, freeclasscd, freename, freefield1, freefield2) values ('PAYMENTDIV06', 'PAYMENTDIV', '入金種別', '6', 'Ｊデビット')
into free (freecd, freeclasscd, freename, freefield1, freefield2) values ('PAYMENTDIV07', 'PAYMENTDIV', '入金種別', '7', '現金書留')
into free (freecd, freeclasscd, freename, freefield1, freefield2) values ('PAYMENTDIV08', 'PAYMENTDIV', '入金種別', '8', 'フレンズ')
into free (freecd, freeclasscd, freename, freefield1, freefield2) values ('PAYMENTDIV09', 'PAYMENTDIV', '入金種別', '9', 'その他')
select * from dual;

/*
 * 個人テーブル（医事連携カナ氏名の項目追加）
 */
alter table person add (medkname varchar2(60));
comment on column person.medkname is '医事連携カナ氏名';

/*
 * 新汎用項目定義（休診日の予約可能を取る）
 */
insert into free (freecd, freeclasscd, freename, freefield1) values ('RSVHOLIDAY', 'HOLIDAY', '休診日に予約をとることができますか？', '0');

/*
 * 新汎用項目定義（管理番号制御フラグ）
 */
insert into free (freecd, freeclasscd, freename, freefield1) values ('RSLCNTL', 'CNTLNOENABLE', '管理番号制御フラグ', '0');