import React from 'react';
import TodaysInfoHeader from './TodaysInfoHeader';
import TodaysComment from './TodaysComment';
import TodaysCourse from './TodaysCourse';
import TodaysOrg from './TodaysOrg';


const TodayInfo = (props) => (
  <div>
    <div style={{ float: 'left', width: '100%' }}><TodaysInfoHeader /></div>
    <div style={{ clear: 'left' }} />
    <div style={{ position: 'absolute', width: '270px' }}><TodaysCourse {...props} /></div><div style={{ marginLeft: '270px' }}><TodaysOrg {...props} /></div>
    <div style={{ clear: 'left' }} />
    <div style={{ float: 'left', width: '100%' }}><TodaysComment {...props} /></div>
  </div>
);

// propTypesの定義
TodayInfo.propTypes = {

};

export default TodayInfo;
