import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import PageLayout from '../../layouts/PageLayout';
import RsvFraSummary from './RsvFraSummary';
import SetCountInfo from './SetCountInfo';
import FriendSummary from './FriendSummary';
import SameName from './SameName';
import VolunteerInfo from './VolunteerInfo';
import TroubleInfo from './TroubleInfo';
import MorningReportHeaderForm from './MorningReportHeaderForm';

const MorningReportMain = (props) => {
  const { rsvfradailydata, friendsdailydata, samenamedata, countinfodata, consultdata, pubnotedata } = props;
  return (
    <PageLayout title="朝レポート照会">
      <div style={{ width: 1200 }}>
        <div style={{ width: '100%' }}>
          <MorningReportHeaderForm />
        </div>
        <div style={{ height: 245, width: '100%' }}>
          <RsvFraSummary data={rsvfradailydata} />
          <FriendSummary data={friendsdailydata} />
          <SameName data={samenamedata} />
        </div>
        <div style={{ height: 340, width: '100%' }}>
          <SetCountInfo data={countinfodata} />
          <VolunteerInfo data={consultdata} />
          <TroubleInfo data={pubnotedata} />
        </div>
      </div>
    </PageLayout>
  );
};
MorningReportMain.propTypes = {
  rsvfradailydata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  friendsdailydata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  samenamedata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  countinfodata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  consultdata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  pubnotedata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

const mapStateToProps = (state) => ({
  rsvfradailydata: state.app.dailywork.morningReport.morningReport.rsvfradailydata,
  friendsdailydata: state.app.dailywork.morningReport.morningReport.friendsdailydata,
  samenamedata: state.app.dailywork.morningReport.morningReport.samenamedata,
  countinfodata: state.app.dailywork.morningReport.morningReport.countinfodata,
  consultdata: state.app.dailywork.morningReport.morningReport.consultdata,
  pubnotedata: state.app.dailywork.morningReport.morningReport.pubnotedata,
});
export default connect(mapStateToProps)(MorningReportMain);
