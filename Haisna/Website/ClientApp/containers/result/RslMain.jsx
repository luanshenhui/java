import React from 'react';
import { reduxForm, getFormValues } from 'redux-form';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import PageLayout from '../../layouts/PageLayout';
import RslDailyList from './RslDailyList';
import RslDetail from './RslDetail';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';

const formName = 'rslMain';

const RslMain = ({ dismode, isLoading }) => (
  <div>
    {isLoading && <CircularProgress />}
    <PageLayout title="結果入力">
      { !dismode && (
        <div style={{ float: 'right', width: '70%' }}>
          <RslDetail />
        </div>
      )}
      { !dismode && (
        <div>
          <RslDailyList />
        </div>
      )}
      { dismode && (
        <RslDetail />
      )}
    </PageLayout>
  </div>
);

// propTypesの定義
RslMain.propTypes = {
  dismode: PropTypes.bool.isRequired,
  isLoading: PropTypes.bool.isRequired,
};

const RslMaineForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(RslMain);
// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    isLoading: state.app.result.result.rslMain.isLoading,
    dismode: state.app.result.result.rslMain.dismode,
  };
};
export default connect(mapStateToProps)(RslMaineForm);
