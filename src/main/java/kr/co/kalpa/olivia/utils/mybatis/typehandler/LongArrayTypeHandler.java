package kr.co.kalpa.olivia.utils.mybatis.typehandler;

import java.sql.Array;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

public class LongArrayTypeHandler extends BaseTypeHandler<List<Long>>{

	/**
	 * SQL문장을 만들때
	 */
	@Override
	public void setNonNullParameter(PreparedStatement ps, int i, List<Long> parameter, JdbcType jdbcType)
			throws SQLException {
		if(parameter == null || parameter.size() == 0) {
			ps.setArray(i, null);
			return;
		}
		
		Long[] ints = parameter.toArray(Long[]::new);
		ps.setArray(i, ps.getConnection().createArrayOf("int", ints));
	}

	@Override
	public List<Long> getNullableResult(ResultSet rs, String columnName) throws SQLException {
		return getArrayListFromSqlArray(rs.getArray(columnName));
	}

	@Override
	public List<Long> getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
		return getArrayListFromSqlArray(rs.getArray(columnIndex));
	}

	@Override
	public List<Long> getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
		return getArrayListFromSqlArray(cs.getArray(columnIndex));
	}
	private List<Long> getArrayListFromSqlArray(Array array) throws SQLException {
		if(array == null) return null;
		Integer[] longs = (Integer[])array.getArray();
		if(longs == null	) {
			return null;
		}
		List<Long> list = new ArrayList<Long>();
		for(int i=0;i<longs.length;i++) {
			list.add(Long.parseLong(longs[i].toString()));
		}
		return list;
	}
}
