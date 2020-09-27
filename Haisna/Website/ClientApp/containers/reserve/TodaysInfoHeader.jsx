import React from 'react';
import moment from 'moment';

// 今日の予定
const TodaysInfoHeader = () => {
  moment.locale('ja', {
    weekdaysMin: ['日', '月', '火', '水', '木', '金', '土'],
  });
  moment.locale('ja');

  return (
    <div>
      <div style={{ width: '97%', marginTop: '8px', padding: '0' }}>
        <div style={{ position: 'absolute', minWidth: '180px', top: '40px', fontSize: '16px', float: 'left' }}>
          <span style={{ fontWeight: 'bolder' }}>{ moment().year() }</span>年
          <span style={{ fontWeight: 'bolder' }}>{ moment().month() + 1 }</span>月
          <span style={{ fontWeight: 'bolder' }}>{ moment().date() }</span>日（{ moment().format('dd') }）
        </div>
      </div>
      <div style={{ width: '97%', marginTop: '8px', padding: '0' }}>
        <div style={{ fontSize: '36px', float: 'right' }}>
          <span style={{ fontFamily: 'arial narrow', color: 'silver' }}>today&apos;s schedule</span>
        </div>
      </div>
      <div style={{ clear: 'both' }} />
      <div style={{ width: '97%', height: '2px', backgroundColor: '#cccccc', padding: '0' }} />
      <div style={{ width: '97%', marginTop: '8px', padding: '0' }}>
        <div style={{ width: '20px', color: '#cccccc', float: 'left' }}>
          ■
        </div>
        <div style={{ width: '260px', float: 'left' }}>
          &nbsp;実施する健康診断コース
        </div>
        <div style={{ width: '20px', color: '#cccccc', float: 'left' }}>
          ■
        </div>
        <div style={{ width: '260px', float: 'left' }}>
          &nbsp;今日お見えになる団体様
        </div>
        <div style={{ clear: 'both' }} />
      </div>

    </div>
  );
};

// プロパティの型を定義する
TodaysInfoHeader.propTypes = {

};

export default TodaysInfoHeader;
