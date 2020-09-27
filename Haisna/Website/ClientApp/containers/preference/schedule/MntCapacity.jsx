import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import PageLayout from '../../../layouts/PageLayout';
import MntCapacityHeaderForm from '../schedule/MntCapacityHeaderForm';
import MntCapacityBody from './MntCapacityBody';


const MntCapacity = (props) => {
  const { showFlag } = props;
  return (
    <PageLayout title="休診日設定">
      <div>
        <MntCapacityHeaderForm {...props} />
        {showFlag === true && (
          <div>
            <MntCapacityBody history={props.history} />
          </div>
        )}
      </div>
    </PageLayout>
  );
};

// propTypesの定義
MntCapacity.propTypes = {
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  showFlag: PropTypes.bool,
};

MntCapacity.defaultProps = {
  showFlag: false,
};

const mapStateToProps = (state) => ({
  showFlag: state.app.preference.schedule.mntCapacityHeadForm.showFlag,
});

export default connect(mapStateToProps)(MntCapacity);
