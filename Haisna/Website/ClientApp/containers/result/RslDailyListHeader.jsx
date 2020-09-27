import React from 'react';
import { reduxForm, Field } from 'redux-form';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import Button from '../../components/control/Button';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import DropDown from '../../components/control/dropdown/DropDown';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';
import { getConsultListRequest } from '../../modules/result/resultModule';
import SectionBar from '../../components/SectionBar';
import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';
import TextBox from '../../components/control/TextBox';

const formName = 'rslDailyListHeader';

const CNTLNO_ENABLED = '1';

const sortkeyitems = [{ value: '', name: '当日ＩＤ順' }, { value: 3, name: '個人ＩＤ順' }];
const getCountitems = [{ value: '10', name: '10件ずつ' }, { value: '20', name: '20件ずつ' }, { value: '50', name: '50件ずつ' }, { value: '*', name: '全件' }];


const RslDailyListHeader = (props) => (
  <ListHeaderFormBase {...props} >
    <SectionBar title="受診者一覧" />
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
      {CNTLNO_ENABLED === props.initialValues.cntlnoflg && (
        <FieldSet>
          <FieldItem>管理番号</FieldItem>
          <Field name="cntlno" component={TextBox} maxLength="4" style={{ imeMode: 'disabled', width: '60px' }} />
        </FieldSet>
      )}
      <FieldSet>
        <FieldItem>件数</FieldItem>
        <Field name="limit" component={DropDown} items={getCountitems} />
        <Button type="submit" value="表示" />
      </FieldSet>
    </FieldGroup>
  </ListHeaderFormBase>
);

// propTypesの定義
RslDailyListHeader.propTypes = {
  history: PropTypes.shape().isRequired,
  initialValues: PropTypes.shape().isRequired,
};

const RslDailyListHeaderForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(RslDailyListHeader);

const mapStateToProps = (state) => ({
  initialValues: {
    csldate: state.app.result.result.rslMain.conditions.csldate,
    cscd: state.app.result.result.rslMain.conditions.cscd,
    sortkey: state.app.result.result.rslMain.conditions.sortkey,
    cntlno: state.app.result.result.rslMain.conditions.cntlno,
    limit: state.app.result.result.rslMain.conditions.limit,
    cntlnoflg: state.app.result.result.rslMenu.cntlnoflg,
  },
});

const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    const [page, limit] = [1, conditions.limit];
    dispatch(getConsultListRequest({ page, limit, ...conditions }));
  },
  initializeList: () => {
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslDailyListHeaderForm));
