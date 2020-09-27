import React from 'react';
import { reduxForm, getFormValues, Field } from 'redux-form';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import DropDown from '../../components/control/dropdown/DropDown';
import DatePicker from '../../components/control/datepicker/DatePicker';
import MessageBanner from '../../components/MessageBanner';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';
import { rslMainLoadRequest, rslMainShowRequest } from '../../modules/result/resultModule';

const formName = 'rslMain';

const CNTLNO_ENABLED = '1';

class RslMenu extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount() {
    const { onLoad } = this.props;
    onLoad();
  }

  // 表示
  handleSubmit(values) {
    const { history, onSubmit } = this.props;
    const params = {};
    params.cscd = values.cscd;
    params.sortkey = values.sortkey;
    params.dayid = values.dayid;
    params.cntlno = values.cntlno;
    params.csldate = values.csldate;
    params.noprevnext = 0;
    params.dismode = false;
    params.page = 1;
    params.limit = 20;
    if (values.dayid !== null && values.dayid !== '' && values.dayid !== undefined) {
      params.noprevnext = 1;
      params.dismode = true;
    }
    onSubmit(
      params,
      () => history.push('/contents/result/rslmain'),
    );
  }

  render() {
    const { handleSubmit, sortkeyitems, message, isLoading, cntlnoflg } = this.props;
    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <MessageBanner messages={message} />
        <FieldGroup>
          <FieldSet>
            <FieldItem>受診日</FieldItem>
            <Field name="csldate" component={DatePicker} />
          </FieldSet>
          <FieldSet>
            <FieldItem>コース</FieldItem>
            <Field name="cscd" component={DropDownCourse} addblank blankname="すべて" />
          </FieldSet>
          <FieldSet>
            <FieldItem>表示順</FieldItem>
            <Field name="sortkey" component={DropDown} items={sortkeyitems} />
          </FieldSet>
          {CNTLNO_ENABLED === cntlnoflg && (
            <FieldSet>
              <FieldItem>管理番号</FieldItem>
              <Field name="cntlno" component={TextBox} maxLength="4" style={{ imeMode: 'disabled', width: '60px' }} />
            </FieldSet>
          )}
          <FieldSet>
            <FieldItem>当日ＩＤ</FieldItem>
            <Field name="dayid" component={TextBox} maxLength="4" style={{ imeMode: 'disabled', width: '60px' }} />
            <span style={{ color: '#999999' }}>（※未入力時には受診者一覧を表示します）</span>
            <Button type="submit" value="表示" />
          </FieldSet>
        </FieldGroup>
        {isLoading && <CircularProgress />}
      </form>
    );
  }
}

const RslMenuForm = reduxForm({
  form: formName,
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(RslMenu);

// propTypesの定義
RslMenu.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  sortkeyitems: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  isLoading: PropTypes.bool.isRequired,
  cntlnoflg: PropTypes.string.isRequired,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      csldate: state.app.result.result.rslMenu.csldate,
      cscd: state.app.result.result.rslMenu.cscd,
      sortkey: state.app.result.result.rslMenu.sortkey,
      dayid: state.app.result.result.rslMenu.dayid,
      cntlno: state.app.result.result.rslMenu.cntlno,
    },
    sortkeyitems: state.app.result.result.rslMenu.sortkeyitems,
    message: state.app.result.result.rslMenu.message,
    isLoading: state.app.result.result.rslMenu.isLoading,
    cntlnoflg: state.app.result.result.rslMenu.cntlnoflg,
  };
};

const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: () => {
    dispatch(rslMainLoadRequest());
  },
  // 表示
  onSubmit: (params, redirect) => {
    dispatch(rslMainShowRequest({ params, redirect }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslMenuForm));
