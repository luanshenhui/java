import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';

import CircularProgress from '../../../components/control/CircularProgress/CircularProgress';
import PageLayout from '../../../layouts/PageLayout';
import MntCapacityListHeaderForm from './MntCapacityListHeaderForm';
import MntCapacityListBody from './MntCapacityListBody';
import { getCourseListRequest, initialMntCapacityListState } from '../../../modules/preference/scheduleModule';

class MntCapacityList extends React.Component {
  componentDidMount() {
    const { startDate, isRetrieval } = this.props;
    this.props.getCourseList({ startDate, isRetrieval });
  }
  componentWillUnmount() {
    const { initializeState } = this.props;
    initializeState();
  }
  render() {
    const { data, isLoading } = this.props;

    if (!data) {
      return null;
    }
    return (
      <PageLayout title="週間予約枠状況表示">
        {isLoading && <CircularProgress />}
        <MntCapacityListHeaderForm {...this.props} />
        <MntCapacityListBody {...this.props} />
      </PageLayout>
    );
  }
}

// propTypesの定義
MntCapacityList.propTypes = {
  getCourseList: PropTypes.func.isRequired,
  initializeState: PropTypes.func.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  startDate: PropTypes.string.isRequired,
  isLoading: PropTypes.bool.isRequired,
  isRetrieval: PropTypes.bool,
  initialDate: PropTypes.string.isRequired,
};
// defaultPropsの定義
MntCapacityList.defaultProps = {
  isRetrieval: false,
};

const mapStateToProps = (state) => ({
  data: state.app.preference.schedule.mntCapacityList.data,
  startDate: state.app.preference.schedule.mntCapacityList.startDate,
  isLoading: state.app.preference.schedule.mntCapacityList.isLoading,
  initialDate: state.app.preference.schedule.mntCapacityList.initialDate,
  isRetrieval: state.app.preference.schedule.mntCapacityList.isRetrieval,
});
const mapDispatchToProps = (dispatch) => ({
  getCourseList: (params) => {
    dispatch(getCourseListRequest(params));
  },
  initializeState: () => {
    dispatch(initialMntCapacityListState());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(MntCapacityList));
